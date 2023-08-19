class PassengersController < ApplicationController
  before_action :authenticate_user!
#to show all booked rides from current user
  def booked_publishes
    booked_passengers = Passenger.where(user_id: current_user.id).order(created_at: :asc)
    rides = booked_passengers.map do |passenger|
      publish = passenger.publish

      time = extract_time(publish.time)
      estimate_time = extract_time(publish.estimate_time)
      reach_time = calculate_reach_time(publish.date, time, estimate_time)
      

      {
        ride: publish,
        booking_id: passenger.id,
        seat: passenger.seats,
        status: passenger.status,
        reach_time: reach_time,
        total_price: publish.set_price * passenger.seats
      }
    end

    render json: { code: 200, rides: rides }, status: :ok
  end

  # def book_publish
  #   publish = Publish.find_by(id: params[:passenger][:publish_id])
  
  #   if publish
  #     if publish.user_id == current_user.id
  #       render json: { code: 422, error: "You cannot book your own published ride" }, status: :unprocessable_entity
  #       return
  #     end
  
  #     if publish.passengers_count > 0
  #       seats = params[:passenger][:seats].to_i
  
  #       if publish.passengers_count >= seats
  #         # Check if the user has previously booked the ride
  #         passenger = Passenger.find_by(publish_id: publish.id, user_id: current_user.id)
  
  #         if passenger && passenger.status == "cancel booking"
  #           # Update the existing passenger record
  #           passenger.update(status: "confirm booking", seats: seats, price: publish.set_price * seats)
  #           publish.update(passengers_count: publish.passengers_count - seats)
  
  #           render json: { code: 200, passenger: passenger }, status: :ok
  #         else
  #           @passenger = Passenger.new(book_params)
  #           @passenger.price = publish.set_price * seats
  #           @passenger.status = "confirm booking"
  
  #           if @passenger.save
  #             publish.update(passengers_count: publish.passengers_count - seats)
  #             render json: { code: 201, passenger: @passenger }, status: :created
  #           else
  #             error_message = @passenger.errors.full_messages.first
  #             render json: { code: 422, error: error_message }, status: :unprocessable_entity
  #           end
  #         end
  #       else
  #         render json: { code: 422, error: "Insufficient seats available" }, status: :unprocessable_entity
  #       end
  #     else
  #       render json: { code: 422, error: "No seats available for this ride" }, status: :unprocessable_entity
  #     end
  #   else
  #     render json: { code: 422, error: "Invalid publish" }, status: :unprocessable_entity
  #   end
  # end
  
  def book_publish
    publish = Publish.find_by(id: params[:passenger][:publish_id])
    passenger = Passenger.find_by(publish_id: publish.id)
  
    if publish.user_id == current_user.id
      render json: { code: 422, error: "You cannot book your own published ride" }, status: :unprocessable_entity
    elsif publish.passengers.exists?(user_id: current_user.id, status: "confirm booking") 
      render json: {code: 422, error: "You have already booked this ride" }, status: :unprocessable_entity
    elsif publish && publish.passengers_count > 0
      seats = params[:passenger][:seats].to_i
      # debugger
      if publish.passengers_count >= seats
        @passenger = Passenger.create(book_params)
        @passenger.status = "confirm booking"
        @passenger.update(price: publish.set_price * seats)
 
        if @passenger.save
          publish.update(passengers_count: publish.passengers_count - seats)
          if publish.passengers_count == 0
            publish.update(status: "full")
          end
          render json: @passenger, status: :created
        else
          render json: @passenger.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Insufficient seats available" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Ride is Full" }, status: :unprocessable_entity
    end
  end

  def cancel_booking
    @passenger = Passenger.find_by(id: params[:id])
  
    if @passenger && @passenger.user_id == current_user.id
      if @passenger.status == "cancel booking"
        render json: { code: 422, error: "Ride has already been cancelled" }, status: :unprocessable_entity
      else
        publish = @passenger.publish
        seats = @passenger.seats
  
        if publish
          publish.update(passengers_count: publish.passengers_count + seats)
        end
  
        @passenger.update(status: "cancel booking")
        render json: { code: 200, message: "Ride successfully cancelled" }, status: :ok
      end
    else
      render json: { code: 422, error: "Invalid passenger or unauthorized" }, status: :unprocessable_entity
    end
  end
  

  def complete_ride
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger && @passenger.user_id == current_user.id
      @passenger.update(status: "ride completed")
      render json: { code: 200, message: "Ride successfully completed" }, status: :ok
    else
      render json: { code: 422, error: "Invalid passenger or unauthorized" }, status: :unprocessable_entity
    end
  end

  private
  def extract_time(datetime)
    datetime&.strftime("%H:%M:%S")
  end
    
  def calculate_reach_time(date, time, estimate_time)
    return unless date && time && estimate_time

    datetime = DateTime.parse("#{date} #{time}")
    estimate_duration = parse_duration(estimate_time)

    reach_datetime = datetime + estimate_duration
    reach_datetime.strftime("%Y-%m-%dT%H:%M:%S.000Z")
  end
  def parse_duration(duration_str)
    parts = duration_str.scan(/\d+/).map(&:to_i)
    seconds = parts.pop
    minutes = parts.pop || 0
    hours = parts.pop || 0
  
    hours.hours + minutes.minutes + seconds.seconds
  end
  

  def book_params
    params.require(:passenger).permit(:publish_id, :seats).merge(user_id: current_user.id)
  end
end

class PublishesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_publish, only: [:show, :update, :destroy]
  before_action :date_must_be_today_or_future, only: [:create]
  
  # GET /publishes
  def index
    @publishes = Publish.all.where(user_id: current_user.id).order(date: :asc, time: :asc)
    render json: { code: 200, data: @publishes }
  end
  
  
  
  #Get publish by id
  def show
    @rides = Passenger.where(publish_id: @publish.id).where.not(status: "cancel booking")
    # @rides = Passenger.where(publish_id: @publish.id)
    @user = User.find_by(id: @publish.user_id)
    @vehicle = Vehicle.find_by(id: @publish.vehicle_id)
    @passengers = Passenger.find_by(id: @publish.id)
    passengers = []
    @rides.each do |ride|
      user = User.find_by(id: ride.user_id)
     
      if user.present?
        passenger = {
          user_id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          dob: user.dob,
          phone_number: user.phone_number,
          phone_verified: user.phone_verified,
          image: user.image.attached? ? url_for(user.image) : nil,
          average_rating: user.average_rating,
          bio: user.bio,
          travel_preferences: user.travel_preferences,
          seats: ride.seats
        }
        passengers << passenger
      end
    end
    time = extract_time(@publish.time)
    estimate_time = extract_time(@publish.estimate_time)
    reach_time = calculate_reach_time(@publish.date, time, estimate_time)
  
    render json: {
      code: 200,
      data: @publish,
      reach_time: reach_time,
  
      passengers: passengers,

   
    }
  end
  

  def create
    # Check if the user's phone_verified is true
    unless current_user.phone_verified
      render json: { code: 403, message: "Phone not verified. Cannot publish ride." }, status: :forbidden
      return
    end
    @publish = current_user.publishes.new(publish_params)
  
    @publish.status = "pending" # Set initial status to "pending"
    # Check if the vehicle_id belongs to the current user's vehicles
    unless current_user.vehicles.exists?(id: @publish.vehicle_id)
      render json: { code: 403, message: "Invalid vehicle_id" }, status: :forbidden
      return
    end
  
    if @publish.save
      render json: {code: 201, publish: @publish}
    else
      render json: {code: 422, publish: @publish.errors, status: :unprocessable_entity }
    end
  end
  

  # PATCH/PUT /publishes/1
  def update
    if @publish.update(publish_params)
      render json: { code: 200, publish: @publish }
    else
      render json: { code: 422, error: @publish.errors.full_messages, status: :unprocessable_entity }, status: 422
    end
  end
  

 
  # DELETE /publishes/1
  def destroy
    @publish.destroy
    render json: { message: 'Publish successfully deleted.' }
  end


  def cancel_publish
    @publish = Publish.find_by(id: params[:id]) 
  
    if @publish.nil?
      render json: { code: 404, message: "Publish not found" }, status: :not_found
    elsif @publish.user_id == current_user.id
      @publish.update(status: "cancelled")
      @passengers = Passenger.where(publish_id: @publish.id)
  
      @passengers.each do |passenger|
        passenger.update(status: "cancelled_by_driver")
      end
  
      render json: { code: 200, message: "Publish successfully cancelled." }
    else
      render json: { code: 403, message: "Permission denied" }, status: :forbidden
    end
  end
  

  # POST /publishes/:id/complete_publish
  def complete_publish
    @publish = Publish.find(params[:id])
      if @publish.update(status: "completed")
        render json: { message: "Ride successfully completed." }
      else
        render json: @publish.errors, status: :unprocessable_entity
      end
   
  end

  private
  def date_must_be_today_or_future
    date = Date.parse(params[:publish][:date])
    if date < Date.current
      render json: { code: 422, message: "Date must be today or a future date" }, status: :unprocessable_entity
    end
  end
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
  

 
  
  def set_publish
    @publish = Publish.find(params[:id])
  end

  def publish_params
    params.require(:publish).permit(:source, :destination, :source_longitude, :source_latitude, :destination_longitude, :destination_latitude, :passengers_count, :add_city, :add_city_longitude, :add_city_latitude, :date, :time, :set_price, :about_ride, :vehicle_id, :book_instantly, :mid_seat, :estimate_time, select_route: {})
    
  end

end

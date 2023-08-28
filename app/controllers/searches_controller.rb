class SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    source_rides = Publish.near([params[:source_latitude], params[:source_longitude]], 5, units: :km, latitude: :source_latitude, longitude: :source_longitude)
                          .where(date: params[:date])
                          .where('passengers_count > 0')
                          .where('passengers_count >= ?', params[:passengers_count].to_i)
                          .where('user_id != ?', current_user.id)
                          .where('status = ?', "pending")
                          .includes(:user) # Include the associated User model to access user attributes
    destination_rides = Publish.near([params[:destination_latitude], params[:destination_longitude]], 5, units: :km, latitude: :destination_latitude, longitude: :destination_longitude)
                                .where(date: params[:date])
                                .where('passengers_count > 0')
                                .where('passengers_count >= ?', params[:passengers_count].to_i)
                                .where('user_id != ?', current_user.id)
                                .where('status = ?', "pending")
                                .includes(:user) # Include the associated User model to access user attributes
    add_city_rides = Publish.near([params[:destination_latitude], params[:destination_longitude]], 5, units: :km, latitude: :add_city_latitude, longitude: :add_city_longitude)
                             .where(date: params[:date])
                             .where('passengers_count > 0')
                             .where('passengers_count >= ?', params[:passengers_count].to_i)
                             .where('user_id != ?', current_user.id)
                             .where('status = ?', "pending")
                             .includes(:user) # Include the associated User model to access user attributes
    @publishes = (source_rides & destination_rides | source_rides & add_city_rides | add_city_rides & destination_rides ).uniq
    if @publishes.length > 0
      apply_filters! # Apply filters if specified
      multiply_set_price(params[:passengers_count].to_i) # Multiply set_price by the number of passengers
      render json: {
        code: 200,
        data: @publishes.map { |publish| serialize_publish(publish) }
      }
    else 
      render json: {
        code: 200,
        message: "No rides found",
        data: []
      }
    end
  end



  def serialize_publish(publish)
    return unless publish && publish.user
  
    time = extract_time(publish.time)
    estimate_time = extract_time(publish.estimate_time)
  
    reach_time = calculate_reach_time(publish.date, time, estimate_time)
  
    {
      id: publish.user.id,
      name: publish.user.first_name,

      reach_time: reach_time,
      image_url: publish.user.image.attached? ? rails_blob_url(publish.user.image) : nil,
      average_rating: publish.user.average_rating,
      about_ride: publish.about_ride,
      publish: publish
     
      
    }
  end
  end


  
private


def multiply_set_price(passengers_count)
  @publishes.each do |publish|
    publish.set_price *= passengers_count
  end
end

#filer
def apply_filters!
  order_by = params[:order_by]

  case order_by
  when "1"
    @publishes.sort_by! { |publish| extract_time(publish.time) }
  when "2"
    @publishes.sort_by!(&:set_price)
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





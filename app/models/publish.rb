class Publish < ApplicationRecord
  
  belongs_to :user
  has_many :passengers
  has_many :users, through: :passengers
  validates :passengers_count, presence: true, numericality: { greater_than_or_equal_to: 1, message: "must be 1 or more" }
  validates :source_latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :source_longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :destination_latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :destination_longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :add_city_latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_nil: true
  validates :add_city_longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true
  validates :time, presence: true
  validates :select_route, presence: true, allow_blank: true

   #for latitude and longitude geocodes
  reverse_geocoded_by :source_latitude, :source_longitude, address: :source
  reverse_geocoded_by :destination_latitude, :destination_longitude, address: :destination
  reverse_geocoded_by :add_city_latitude, :add_city_longitude, address: :add_city
  enum status: { pending: 'pending', cancelled: 'cancelled', completed: 'completed', full: 'full' }
  
end
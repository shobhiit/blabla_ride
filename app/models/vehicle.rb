class Vehicle < ApplicationRecord
  belongs_to :user
  #validation 
  validates :country, presence: true
  validates :vehicle_number, presence: true
  validates :vehicle_brand, presence: true
  validates :vehicle_name, presence: true
  validates :vehicle_type, presence: true
  validates :vehicle_color, presence: true
  validates :vehicle_model_year, presence: true
end

class Passenger < ApplicationRecord
  belongs_to :user
  belongs_to :publish
  has_many :chats
  validate :validate_unique_booking, on: :create
  validates :price, presence: true
  validates :seats, presence: true
  private
  def validate_unique_booking
    if Passenger.exists?(publish_id: publish_id, user_id: user_id)
      errors.add(:base, "You have already booked this ride")
    end
  end
end

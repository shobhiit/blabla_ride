class Message < ApplicationRecord
   
    belongs_to :chat
    validates :receiver_id, presence: true
    # Assuming you have a `User` model representing the users participating in the chat
    #belongs_to :user
    validate :validate_receiver_id_exists

    validate :validate_sender_and_receiver

    def validate_sender_and_receiver
    if sender_id == receiver_id
        errors.add(:base, 'Sender and receiver must be different users')
    end
    end

    def validate_receiver_id_exists
    errors.add(:receiver_id, 'does not exist') unless User.exists?(receiver_id)
    end
end

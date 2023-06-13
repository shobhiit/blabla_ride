class Message < ApplicationRecord
   
    belongs_to :chat
    # Assuming you have a `User` model representing the users participating in the chat
    belongs_to :sender, class_name: 'User'
    belongs_to :receiver, class_name: 'User'
end

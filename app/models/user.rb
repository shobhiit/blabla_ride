class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  require 'two_factor'
  has_many :vehicles
  has_many :sender_chats, class_name: 'Chat', foreign_key: 'sender_id'
  has_many :receiver_chats, class_name: 'Chat', foreign_key: 'receiver_id'
  #has_many :device_infos  
  has_many :publishes
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

        validates :email, presence: true, uniqueness: true
        #validates :password, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)[\w\W]{8,}\z/ }, length: { minimum: 8 }
        validates :encrypted_password, presence: true
        #custom validation on password 
        validate :password_complexity
        #custom validation on image
        validate :image_format
        #for chatting
        has_many :messages
        #for ratting 
        has_many :given_ratings, class_name: 'Rating', foreign_key: 'rating_user_id'
        has_many :received_ratings, class_name: 'Rating', foreign_key: 'rated_user_id'

        
        before_validation :trim_first_name
        validates :first_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
        
        before_validation :trim_last_name
        validates :last_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
        validates :phone_number, uniqueness: true, length: { is: 10 }, numericality: { only_integer: true }, allow_blank: true

        validate :dob_must_be_more_than_14_years_ago
        validates :dob, presence: true
        validates :title, presence: true
        has_one_attached :image
        before_create :create_activation_digest


      def image_url
        # Assuming you have an `image` attribute that stores the image file name
        if image.attached?
          Rails.application.routes.url_helpers.url_for(image)
        else
          # Return a default image URL or handle the case when no image is attached
          # For example:
          #ActionController::Base.helpers.asset_path('default-avatar.png')
          nil
        end
      end         

      #notifications
      def send_notification_to_user(title, description)
        payload = {payload: { title: title , description: description } }
        android_condition = "device_type = 'android' and user_id = #{id.to_i}"
        ios_condition = "device_type = 'ios' and user_id = #{id.to_i}"
        send_notification(payload, android_condition, 'android')
        send_notification(payload, ios_condition, 'ios')
      end
    
      def send_notification(payload, condition, device_type)
        tokens = DeviceInfo.where(condition).pluck(:device_token).compact
          DeviceInfo.send_notification(tokens, payload, device_type)
      end

      
      #validations 
      def trim_first_name
        first_name.strip! if first_name.present?
      end
      def trim_last_name
        last_name.strip! if last_name.present?
      end

      def dob_must_be_more_than_14_years_ago
        if dob.present? && dob > 14.years.ago.to_date
          errors.add(:dob, "must be more than 14 years ago")
        end
      end

      # Add a method to calculate the average rating
      def average_rating
        received_ratings.average(:value)
      end

      def update_average_rating
        update(average_rating: received_ratings.average(:value))
      end
     # for sending otp and verification
      def send_passcode
        response = TwoFactor.send_passcode(phone_number)
        if response && response['Status'].to_s.downcase == 'success'
          update_column(:session_key, response['Details'])
          true
        else
          false
        end
      end
      
      
      def verify_passcode(passcode)
        TwoFactor.verify_passcode(session_key, passcode)['Status'].to_s.downcase == 'success'
      end
     #password validation 
      def password_complexity
        if password.present? && !password.match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\W)/)
          errors.add(:password, "must include at least one lowercase letter, one uppercase letter, and one special character")
        end
      end
      
  # for email verification 
      def send_activation_email
        UserMailer.account_activation(self).deliver_now
      end
      
      def activate
        update_columns(activated: true, activated_at: Time.zone.now)
      end
    
      attr_accessor :activation_token
    
      def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
      end
    
      # private
    
      def create_activation_digest
        self.activation_token = SecureRandom.urlsafe_base64
        self.activate_token = self.activation_token
        self.activation_digest = User.digest(self.activation_token)
      end
    
      def self.digest(token)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(token, cost: cost)
      end

      # for image validation
      def image_format
        return unless image.attached?
    
        unless image.content_type.in?(%w[image/jpeg image/png image/png])
          errors.add(:image)
        end
      end
end
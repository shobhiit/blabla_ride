class PasswordResetController < ApplicationController
    before_action :verify_sign_in , only: [:send_otp, :verify_otp, :reset_password]
  
      def send_otp
          user = User.find_by(email: params[:email])
          if user
            otp = generate_otp
            user.update(otp:otp)
            user.save!
        
            UserMailer.otp_email(user, otp).deliver_now
        
            render json: {code: 200, message: "OTP sent successfully" }, status: :ok
          else
            render json: {code: 404, error: "User not found" }, status: :not_found
          end
        end
        
        def verify_otp
          user = User.find_by(email: params[:email], otp: params[:otp])
          if user
            user.update(activated: true)
            render json: { code: 200, message: "OTP verified successfully", email: user.email }, status: :ok
          else
            render json: { code: 422, error: "Invalid OTP or email" }, status: :unprocessable_entity
          end
        end
        
    
        def reset_password
        user = User.find_by(email: params[:email])
          if user
            if params[:password] != params[:password_confirmation]
              render json: { error: "Password and password confirmation do not match" }, status: :unprocessable_entity
            elsif user.activated? # Check if OTP is verified
              if user.update(password: params[:password], password_confirmation: params[:password_confirmation],activated: false)
                
                render json: {code: 200, message: "Password updated successfully" }, status: :ok
              else
                render json: {code: 422, error: user.errors.full_messages }, status: :unprocessable_entity
              end
            else
              render json: {code: 422, error: "OTP not verified" }, status: :unprocessable_entity
            end
          else
            render json: {code: 422, error: "Invalid user" }, status: :unprocessable_entity
          end
        end
    private
  
    def verify_sign_in
      user = current_user
      if user
        render json: {code: 422, error: "Action not allowed for signed-in users" }, status: :unprocessable_entity
      end
    end
     
    def generate_otp
      SecureRandom.random_number(1000..9999)
    end  
    end
    
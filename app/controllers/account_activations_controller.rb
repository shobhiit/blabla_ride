class AccountActivationsController < ApplicationController
  def create
      user = User.find_by(email: params[:email])
      if user && !user.activated?
        user.send_activation_email
        render json: "Activation email sent. Please check your email."
      else
        render json: "already activated."
      end
  end

    def edit
      user = current_user
  
      if user && !user.activated? 
        user.activate
        render json: { message: "Account activated!" }, status: :ok
      else
        render json: { error: "Invalid activation link" }, status: :unprocessable_entity
      end
    end
end
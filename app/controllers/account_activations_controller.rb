class AccountActivationsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user && !user.activated?
      user.send_activation_email
      render(json:{
        status: {code: 200, message: "Activation email sent. Please check your email."}}, status: :ok)
    else
      render(json:{
        status: {code: 403, error: 'failed to send passcode'}}, status: :forbidden)
    end
  end
  def edit
    user = User.find_by(activate_token: params[:activate_token])
    
    if user && !user.activated? && user.activate

      
      render(json:{
        status: {code: 200, message: "Account activated!"}}, status: :ok)
    else
      render(json: {
        status: { code: 422, error: "Invalid activation link" }
      }, status: :unprocessable_entity)
    end
  end
end
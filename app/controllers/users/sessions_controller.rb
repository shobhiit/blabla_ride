
class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!
  respond_to :json
   #find user by id
  def find_user_by_id
    user = User.find(params[:id])

    if user
      render json: { code: 200, user: user,  image_url: user.image.attached? ? url_for(user.image) : nil }, status: :ok
    else
      render json: {code: 404, error: 'User not found' }, status: :not_found
    end
  end
  
  def respond_with(resource, options = {})
    
    if current_user.nil?
      render json: {
        status: { code: 400, error: resource.errors.full_messages.join(", ") }
      }, status: :bad_request
    else
      render json: {
        status: { code: 200, message: 'User Signed in successfully', data: current_user, image_url: current_user.image.attached? ? url_for(current_user.image) : nil }
      }, status: :ok
    end
  end
  
  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],Rails.application.credentials.fetch(:secret_key_base)).first
    # debugger
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200,
        message: "Signed out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "User has no active session"
      }, status: :unauthorized
    end
  end
end













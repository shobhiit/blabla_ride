class UserImagesController < ApplicationController
    before_action :authenticate_user!
    before_action :only => [:update]

    def update
        Rails.logger.info(params.inspect)
        user = current_user
        if current_user.image.attach(params[:image])
            render json: { 
            status: {code: 200, message: 'Image successfully updated'},
            data: {
            user: user,
            image_url: url_for(user.image)
            }
        }
        else
            render json: { 
            status: {code: 422, message: 'must be a JPEG or PNG file'}
            }, status: :unprocessable_entity
        end
    end
          
end
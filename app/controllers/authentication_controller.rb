class AuthenticationController < ApplicationController
  
    def phone  
        @user = User.find_by_phone_number(params[:phone_number])
        if @user && @user.send_passcode
          render(json:{
            status: {code: 200, message: 'Sent passccode'}}, status: :ok)
        else
          render(json:{
            status: {code: 401, error: 'failed to send passcode'}}, status: :unauthorized)
        end
    end
    
    def verify
      @user = User.find_by_phone_number(params[:phone_number])
    
      if @user && @user.verify_passcode(params[:passcode])
        @user.update(phone_verified: true)
        render(json: {
          status: { code: 200, message: 'Phone number verified!' }
        }, status: :ok)
      else
        render(json: {
          status: { code: 401, error: 'Failed to verify passcode' }
        }, status: :unauthorized)
      end
    end   
     
end



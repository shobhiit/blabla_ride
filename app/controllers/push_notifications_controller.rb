require_relative '../../lib/push_messenger'


class PushNotificationsController < ApplicationController
    def send_notification
      connections = params[:connections]
      tokens = params[:tokens]
      payload = params[:payload]
  
      if connections.blank? || tokens.blank? || payload.blank?
        render json: { error: "Invalid parameters" }, status: :unprocessable_entity
        return
      end
  
      push_messenger = determine_push_messenger(connections)
      if push_messenger.nil?
        render json: { error: "Invalid app name" }, status: :unprocessable_entity
        return
      end
  
      push_messenger.deliver(connections, tokens, payload)
  
      render json: { message: "Push notification sent successfully" }
    end
  
    private
  
    def determine_push_messenger(connections)
      case connections
      when 1
        PushMessenger::Fcm.new
      when 2
        PushMessenger::Ios.new
      else
        nil
      end
    end
  end
    
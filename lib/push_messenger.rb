require 'fcm'

module PushMessenger
  class Fcm
    def deliver(app, tokens, payload)
      fcm = FCM.new(ENV['AAAA4Rc0jBM:APA91bEChNc5KYTHEDQVFgchtuHqV9QZhFfU7JmtQK-hjHTYqQ460srFncoC04bmZaXVSm70aFKtmPA4XjEOQwJZPf1Ytoko3LH8OF1ShSKz-s0vcveY4-T-cfaz7Q8Tfr-N4k9OI8Cd'])  # Replace ENV['FCM_SERVER_KEY'] with your actual FCM server key

      message = {
        registration_ids: tokens,
        data: payload,
        notification: {
          title: payload[:title],
          body: payload[:body]
        }
      }

      response = fcm.send(message)

      # Handle the response as needed
      if response['success'] == 1
        # Notification sent successfully
      else
        # Failed to send notification
      end
    end
  end

  class Ios
    def deliver(app, tokens, payload)
      n = Rpush::Apns::Notification.new
      n.app = Rpush::Apns::App.find_by_name(app)
      n.device_token = tokens
      n.data = payload
      n.alert = payload[:title]
      n.save!
    end
  end
end

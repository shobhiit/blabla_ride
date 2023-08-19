class DropDeviceInfosRpushAppsRpushFeedbackRpushNotifications < ActiveRecord::Migration[7.0]
  def change
    drop_table :device_infos
    drop_table :rpush_apps
    drop_table :rpush_feedback
    drop_table :rpush_notifications
  end
end

class AddPhoneVerifiedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone_verified, :boolean
  end
end

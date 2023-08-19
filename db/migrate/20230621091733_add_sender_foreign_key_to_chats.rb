class AddSenderForeignKeyToChats < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :chats, :users, column: :sender_id
    add_foreign_key :chats, :users, column: :receiver_id
  end
end

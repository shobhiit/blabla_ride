class AddChatReferenceToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :chat, foreign_key: true
  end
end

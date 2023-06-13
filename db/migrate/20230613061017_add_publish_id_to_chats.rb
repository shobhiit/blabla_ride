class AddPublishIdToChats < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :publish_id, :integer
  end
end

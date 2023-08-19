class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [:show, :update, :destroy]
  def index
    sender_chats = current_user.sender_chats.map { |chat| chat_response(chat) }
    receiver_chats = current_user.receiver_chats.map { |chat| chat_response(chat) }
    chats = sender_chats + receiver_chats
    render json: { code: 200, chats: chats }, status: :ok
  end
  #get chat by chat_id
  def get_chat
    chat = Chat.find_by(id: params[:chat_id])

    if chat
      render json: { code: 200, chat: chat_response(chat) }, status: :ok
    else
      render json: { code: 404, error: 'Chat not found' }, status: :not_found
    end
  end

  def show
    render json: { code: 200, chat: chat_response }, status: :ok
  end

  def create
    chat = Chat.find_or_initialize_by(chat_params)
    chat.sender_id = current_user.id
  
    # Check if a chat already exists with the same publish_id, sender_id, and receiver_id
    existing_chat = Chat.find_by(
      publish_id: chat.publish_id,
      sender_id: [chat.sender_id, chat.receiver_id],
      receiver_id: [chat.sender_id, chat.receiver_id]
    )
  
    if existing_chat
      render json: { code: 422, error: 'Chat already exists', chat: existing_chat }, status: :unprocessable_entity
    elsif chat.save
      render json: { code: 201, chat: chat }, status: :created
    else
      render json: { code: 422, error: chat.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def update
    if @chat.update(chat_params)
      render json: { code: 200, chat: @chat }, status: :ok
    else
      render json: { code: 422, error: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @chat.destroy
    render json: { code: 200, message: 'Chat deleted successfully' }, status: :ok
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:receiver_id, :publish_id)
  end

  def chat_response(chat)
    publish = Publish.find_by(id: chat.publish_id)
    {
      id: chat.id,
      receiver_id: chat.receiver_id,
      sender_id: chat.sender_id,
      publish_id: chat.publish_id,
      publish: publish,
      receiver: chat.receiver,
      sender: chat.sender,
      receiver_image: chat.receiver.image_url,
      sender_image: chat.sender.image_url,
     
    }
  end
end

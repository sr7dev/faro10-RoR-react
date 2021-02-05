class Api::V1::MessagesController < Api::Controller
  before_action :set_message, only: [:destroy, :mark_as_read, :mark_as_unread]

  def index
    messages = current_user.messages.unarchived.includes(:clinician)
    respond_with messages, each_serializer: MessageSerializer
  end

  def create
    authorize! :create, Message
    message = current_user.messages.new(message_params)

    if message.save
      render json: message, status: :ok
      MessageMailer.delay.message_sent(message)
    else
      render json: message.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @message && @message.archive
      authorize! :destroy, @message
      render json: @message, status: :ok
    else
      render_not_found
    end
  end

  def mark_as_read
    if @message
      authorize! :update, @message
      if @message.update(read: true)
        render json: @message, status: :ok
      else
        render json: @message, status: :unprocessable_entity
      end
    else
      render_not_found
    end
  end

  def mark_as_unread
    if @message
      authorize! :update, @message
      if @message.update(read: false)
        render json: @message, status: :ok
      else
        render json: @message, status: :unprocessable_entity
      end
    else
      render_not_found
    end
  end

  private

  def set_message
    @message = current_user.messages.find_by(id: params[:id])
  end

  def message_params
    params.require(:message).permit(:body, :member_id)
  end

  def render_not_found
    res = { errors: ["No message found with id #{params[:id]}."] }
    render json: res, status: 404
  end
end

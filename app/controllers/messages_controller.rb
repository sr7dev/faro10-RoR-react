class MessagesController < ApplicationController
  def create
    message = current_user.messages.new(message_params)

    if message.save
      flash[:success] = "Message sent successfully"
      redirect_to patients_path
      MessageMailer.delay.message_sent(message)
    else
      flash[:danger] = "There was a problem sending your message"
      redirect_to patients_path
    end
  end

  def destroy
    message = Message.find_by(id: params[:id])

    if message && message.archive
      flash[:success] = "Message deleted successfully"
      redirect_to team_users_path
    else
      flash[:error] = "There was a problem deleting the message"
      redirect_to team_users_path
    end
  end

  def edit
    # @prescription = Prescription.edit(params[:id])
    @messages = current_user.messages
    @message = Message.find(message_params[:id])

  end

  def update
    @messages = current_user.messages
    @message = Message.find(message_params[:id])
    respond_to do |format|
      if @message.update_attributes(message_params)
        flash[:success] = "Message Updated"
      else
        flash[:danger] = "There was a problem"
      end
    end
  end

  # Member marking a Message as "READ"
  def mark_as_read
    @message = Message.find(params[:id])
    # current_user.messages.where(read: 0).update(read: 1)
    if @message.present?
      if @message.update(read: true)
        flash[:success] = "Message marked as Read."
      else
        flash[:danger] = "There was an issue"
      end
    else
      flash[:danger] = "There was an issue"
    end
    redirect_back fallback_location: root_path
  end

  # Member marking a Message as "READ"
  def mark_as_unread
    @message = Message.find(params[:id])
    # current_user.messages.where(read: 0).update(read: 1)
    if @message.present?
      if @message.update(read: false)
        flash[:success] = "Message marked as Unread."
      else
        flash[:danger] = "There was an issue"
      end
    else
      flash[:danger] = "There was an issue"
    end
    redirect_back fallback_location: root_path
  end

  private

  def message_params
    params.require(:message).permit(:body, :read, :member_id)
  end
end

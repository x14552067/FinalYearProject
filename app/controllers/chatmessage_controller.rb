class ChatmessageController < ApplicationController
  def create
    message = Chatmessage.new(chatmessage_params)

    if current_user.lecturer.nil?
      message.student = current_user.student
      @user_payload = current_user.student
    else
      message.lecturer = current_user.lecturer
      @user_payload = current_user.lecturer
    end

    if message.save

      ActionCable.server.broadcast 'chat_messages',
                                   message: message.content,
                                   user: @user_payload.first_name
      head :ok

    else
      redirect_to classsessions_path
    end
  end

  private

  def chatmessage_params
    params.require(:chatmessage).permit(:content, :session_id)
  end
end

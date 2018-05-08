class ClasssessionsController < ApplicationController
  layout 'session'

  def index
    
  end

  def show

    @session = Classsession.find(params[:id])
    @messages = @session.chatmessages
    @user = current_user

    @questions = @session.questionmessages
    @answers = @session.answermessages

    #Combine the Questions and Answers into one collection and sort it by the created at date.
    # This should hopefully retain correct order. The variable name is meant to read Q & A
    @qanda = ( @questions + @answers ).sort_by(&:created_at)

    #This check is used to find out what the "User Type" is. This is either Lecturer or Student
    # I have abstracted the identifier into a random code just to make it more difficult for Students
    # To guess how to send messages as a Lecturer in the case of Malicious Activity

    if current_user.lecturer.nil?
      @user_type = get_student_code
      render 'student_show'
    else
      @user_type = get_lecturer_code
      render 'lecturer_show'
    end

  end

  def new
    @session = Classsession.new
    @classgroup = params[:classgroup]


  end

  def create

    #Manually Set all the Fields because some of the fields are set behind the scenes
    @session = Classsession.new
    @session.topic = classsession_params[:topic]
    @session.start_time = DateTime.now
    @session.end_time = classsession_params[:end_time]
    @session.is_active = true
    @classgroup_id = classsession_params[:classgroup_id]
    @classgroup = Classgroup.find(@classgroup_id)
    @session.classgroup = @classgroup

    if @session.save
      redirect_to @session
    else
      render 'new'
    end
  end

  def destroy

  end

  private
  def classsession_params
    params.require(:classsession).permit(:topic, :end_time, :classgroup_id)
  end
end

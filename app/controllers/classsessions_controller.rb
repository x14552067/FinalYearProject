require 'json'
class ClasssessionsController < ApplicationController
  #SUPER AWESOME snippet of code suggestion from stack overflow to change the layout for a controller based on the action!
  #https://stackoverflow.com/questions/3025784/rails-layouts-per-action
  layout "session", only: [:show]

  def index
    redirect_to '/dashboard'
  end

  def show

    #Find the session we want to join
    @session = Classsession.find(params[:id])

    #Get all the Chat messages for the session
    @messages = @session.chatmessages

    #Get all the Questions asked for the session
    @questions = @session.questionmessages

    #Get all the answers given for a session
    @answers = @session.answermessages

    #Combine the Questions and Answers into one collection and sort it by the created at date.
    # This should hopefully retain correct order. The variable name is meant to read Q & A
    @qanda = ( @questions + @answers ).sort_by(&:created_at)

    #Get the current user logged in (Used for logic in the session)
    @user = current_user

    #Populate the graph with no data to begin with!
    @text_poll_data = {
        'Yes' => 0,
        'No' => 0
    }

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

    #Check if a Sessions already exists, if they do, make the new ID equal to the next available ID.
    # We do this because we need to generate the Session Key based on the ID of the Session, which is typically
    # Only generated when the Record is saved.
    if (Classsession.any?)
      @id = Classsession.maximum(:id).next
    else
      @id = 0
    end


    @session.id = @id
    @session.session_key = generate_key(@id)

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

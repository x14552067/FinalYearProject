class ClasssessionsController < ApplicationController
  layout 'session'

  def index
    
  end

  def show
    @messages = Chatmessage.all
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

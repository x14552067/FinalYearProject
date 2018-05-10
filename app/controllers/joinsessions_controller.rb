class JoinsessionsController < ApplicationController

  def show
    redirect_to action: 'new'
  end

  def new
    @join_session = Joinsession.new
  end

  def create

    #Get the enrollments key as a param from the form
    @session_key = params[:joinsession][:session_key]

    #Create an enrollments which is only used to trigger errors on the form
    @join_session= Joinsession.new
    @join_session.session_key = @session_key

    #Find the class with the enrollments key
    @session_to_join = Classsession.where(session_key: @session_key)
    @session_to_join = @session_to_join.to_ary.first

    p "#################"
    p @session_to_join
    p @join_session

    #Check if the class exists or we are a student
    if !@session_to_join.nil? and current_user.student.present?

      @stu = current_user.student

      p "#############"
      p @session_to_join
      p @session_to_join.students
      p current_user.student

      @session_to_join.students << @stu
      redirect_to classsession_path(@session_to_join)

    else
      @join_session.errors[:session_key] << ["Invalid Session Key"]
      render 'new'
    end
  end

  private
  def joinsession_params
    params.require(:joinsessions).permit(:session_id)
end

end
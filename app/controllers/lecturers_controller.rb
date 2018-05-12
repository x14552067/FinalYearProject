class LecturersController < ApplicationController
  def show
    @lecturer = Lecturer.find(params[:id])

    #Check to see if the Lecturer is trying to view their own profile or an Admin is
    if current_user.is_admin? or current_user.lecturer == @lecturer

    #If not, redirect them away
    else
      redirect_to dashboard_url
    end
  end

  def new
    @lecturer = Lecturer.new
  end

  def create


    #Create a new Lecturer
    @lecturer = Lecturer.new(lecturer_params)

    #Find the Student who we are promoting
    @student_to_promote = Student.find(@lecturer.student_id)

    #Copy Across their details
    @lecturer.first_name = @student_to_promote.first_name
    @lecturer.last_name = @student_to_promote.last_name

    #Remove the Student ID
    @lecturer.student_id = nil

    #Get the Account we will associate the Lecturer to and Remove Student From
    @user_account = @student_to_promote.user
    @user_account.lecturer = @lecturer

    @student_to_promote.destroy

    respond_to do |format|
      if @lecturer.save
        format.html {redirect_to dashboard_index_url }

      else
        format.html { render :new }
        format.json { render json: @lecturer.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_admin



  end


  def lecturer_params
    params.require(:lecturer).permit(:first_name, :last_name, :student_id)
  end


end

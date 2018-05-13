class StudentsController < ApplicationController

  def show
    @student = Student.find(params[:id])

    #Check to see if the Student is trying to view their own profile or an admin is
    if current_user.is_admin? or current_user.student == @student

    #If not, redirect them away
    else
      redirect_to dashboard_index_url
    end
  end

  def new
    @student = Student.new
  end

  def create

    @student = Student.new(student_params)
    @student.user = current_user

    respond_to do |format|
      if @student.save
        format.html {redirect_to dashboard_index_url }

      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_support

    @student = Student.find(params[:student_id])
    @classgroup = Classgroup.find(params[:classgroup])

    ClassistantMailer.with(student: @student, classgroup: @classgroup).support_email.deliver_now

    redirect_to('/classgroups/' + @classgroup.id.to_s)


  end

  def send_attendance
    @student = Student.find(params[:student_id])
    @classgroup = Classgroup.find(params[:classgroup])

    ClassistantMailer.with(student: @student, classgroup: @classgroup).attendance_email.deliver_now

    redirect_to('/classgroups/' + @classgroup.id.to_s)
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :classgroup)
  end

end

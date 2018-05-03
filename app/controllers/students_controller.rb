class StudentsController < ApplicationController
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

  def student_params
    params.require(:student).permit(:first_name, :last_name)
  end

end

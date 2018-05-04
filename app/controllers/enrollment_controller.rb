class EnrollmentController < ApplicationController

  def index
    render 'enroll'
  end

  def create

    @enrollment_key = params["Enrollment Key"]

    p "#####################"
    p @enrollment_key
    p "#####################"

    @class_to_join = Classgroup.where(unique_id: @enrollment_key)

    if @class_to_join.nil?

    else
      if (current_user.student.present?)
        @class_to_join.students << current_user.student
        @class_to_join.save
        redirect_to 'success'
      end
    end
  end

  private
  def enrollment_params
    params.permit("Enrollment Key")
  end

end

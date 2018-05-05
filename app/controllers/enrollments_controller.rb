class EnrollmentsController < ApplicationController

  def show
    redirect_to action: 'new'
  end

  def new
    @enrollment = Enrollment.new
  end

  def create

    #Get the enrollments key as a param from the form
    @enrollment_key = params[:enrollment][:enrollment_key]

    #Create an enrollments which is only used to trigger errors on the form
    @enrollment = Enrollment.new
    @enrollment.enrollment_key = @enrollment_key

    #Find the class with the enrollments key
    @class_to_join = Classgroup.where(unique_id: @enrollment_key)
    @class_to_join = @class_to_join.to_ary.first

    #Check if the class exists or we are a student
    if !@class_to_join.nil? and current_user.student.present?

      if(@class_to_join.students.where(:user_id => current_user.id).exists?)

        p "###################"

        p "###################"

        @enrollment.errors[:enrollment_key] << ["You are already enrolled in that class"]
        render 'new'
      else

        #Get the student logged in
        @current_student = Student.find(current_user.student.id)

        #Enroll him in the class and save it
        @class_to_join.students << @current_student
        @class_to_join.save

        #Render the dashboard for now
        redirect_to '/dashboard'

      end

    else
      @enrollment.errors[:enrollment_key] << ["Invalid Enrollment Key"]
      render 'new'
    end
  end

  private
  def enrollment_params
    params.permit("Enrollment Key")
  end

end

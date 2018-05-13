class DashboardController < ApplicationController
  def index
    if current_user.lecturer.nil?
      @student = current_user.student
      render 'student'
    else
      @lecturer = current_user.lecturer
      render 'lecturer'
    end

  end
end

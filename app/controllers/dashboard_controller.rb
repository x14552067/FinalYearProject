class DashboardController < ApplicationController
  def index

    if current_user.lecturer.nil?
      render 'student'
    else
      render 'lecturer'
    end

  end
end

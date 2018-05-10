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

  end

  def create

  end

end

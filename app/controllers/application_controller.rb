class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :check_user_has_identity

  def after_sign_in_path_for(resource_or_scope)
    '/dashboard' # Or :prefix_to_your_route
  end

  def check_user_has_identity
    if user_signed_in? and current_user.lecturer.nil? and current_user.student.nil? and not request.fullpath == '/students/new'
        redirect_to '/students/new' unless request.fullpath == '/students'
    end
  end

  def get_user_type
    if current_user.lecturer.nil?
      return current_user.student
    else
      return current_user.lecturer
    end
  end

  def get_lecturer_code
    return 191
  end

  def get_student_code
    return 4
  end

  def generate_key(id)
    @key = (id * 1000 + rand(999))
    return @key
  end

end
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  def after_sign_in_path_for(resource_or_scope)
    '/static_pages/index' # Or :prefix_to_your_route
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

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  def after_sign_in_path_for(resource_or_scope)
    '/static_pages/index' # Or :prefix_to_your_route
  end
end

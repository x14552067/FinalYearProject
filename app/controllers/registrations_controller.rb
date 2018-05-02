class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    '/students/new/' # Or :prefix_to_your_route
  end

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(params[:signup])

    if @signup.save
      sign_in @signup.user
      redirect_to projects_path, notice: 'You signed up successfully.'
    else
      render action: :new
    end
  end

end

Rails.application.routes.draw do

  mount ActionCable.server => '/cable'


  authenticate :user do
    resources :lecturers do
      get :set_admin

    end
    resources :students
    resources :dashboard
    resources :classgroups
    resources :classsessions do
      get :review
      get :end_session
    end
    resources :quiz
    resource :enrollment
    resource :joinsession

  end

  get 'static_pages/index'
  devise_for :users, controllers: { registrations: "registrations", sign_in: "login" }
  root 'static_pages#index'

end

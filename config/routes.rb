Rails.application.routes.draw do

  mount ActionCable.server => '/cable'


  authenticate :user do
    resources :lecturers
    resources :students
    resources :dashboard
    resources :classgroups
    resources :classsessions
    resources :quiz
    resource :enrollment
    resource :joinsession

  end

  get 'static_pages/index'
  devise_for :users, controllers: { registrations: "registrations", sign_in: "login" }
  root 'static_pages#index'

end

Rails.application.routes.draw do

  authenticate :user do
    resources :students
  end

  get 'static_pages/index'
  devise_for :users, controllers: { registrations: "registrations", sign_in: "login" }
  root 'static_pages#index'

end

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", sign_in: "login" }

  authenticate :user do
    get 'static_pages/home'
  end
    root 'static_pages#home'
end

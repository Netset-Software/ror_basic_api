Rails.application.routes.draw do

  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

          post "users/login" => "users#sign_in"
          post "users" => "users#sign_up"
          put "users" => "users#create_profile"
          post "users/forgot_password" => "users#forgot_password"

    end
  end

end

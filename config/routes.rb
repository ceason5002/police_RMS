Rails.application.routes.draw do
  devise_for :users

  # Admin namespace
  namespace :admin do
    root "dashboard#index"
    resources :officers do
      member { patch :toggle_active }
    end
    resources :crime_cases do
      member do
        patch :close
        patch :reopen
      end
    end
    resources :incidents do
      member { patch :toggle_flag }
    end
    resources :units
    resources :people
    resources :users do
      member { patch :toggle_active }
    end
    resources :audit_logs, only: [:index]
  end

  # Main app
  resources :evidences
  resources :arrests
  resources :vehicles
  resources :people
  resources :officers
  resources :incidents

  get "up" => "rails/health#show", as: :rails_health_check

  root "incidents#index"
end
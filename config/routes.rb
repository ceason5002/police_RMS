Rails.application.routes.draw do
  devise_for :users

  # CAD namespace
  namespace :cad do
    root "dashboard#index"

    resources :calls do
      member do
        patch :advance_status
        post  :add_note
        post  :assign_unit
        delete :remove_unit
        post  :send_to_rms
      end
      collection do
        get :active_calls_data
      end
    end

    resources :cad_units do
      member do
        patch :change_status
      end
    end

    resources :bolos do
      member do
        patch :cancel
        patch :resolve
      end
    end

    resources :reports, only: [:index] do
      collection do
        get :call_history
        get :response_times
        get :shift_summary
        get :audit_trail
      end
    end
  end

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
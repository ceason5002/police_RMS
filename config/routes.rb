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
    resources :community_requests do
      member { patch :resolve; patch :assign }
    end
    resources :community_tips do
      member { patch :review; patch :close }
    end
    resources :news_posts
    resources :community_events
    resources :alert_subscriptions, only: [:index, :destroy]
    resources :spotlights, only: [:index, :update]
    resources :officer_trainings
    resources :fleet_vehicles do
      resources :fleet_logs, only: [:create, :destroy]
    end
    resources :officer_complaints
  end

  # Community portal (public)
  namespace :community do
    root "home#index"
    get  "crime-map",      to: "crime_map#index",  as: :crime_map
    get  "crime-map/data", to: "crime_map#data",   as: :crime_map_data
    resources :requests,       only: [:new, :create]
    resources :tips,           only: [:new, :create]
    resources :alerts,         only: [:new, :create, :destroy]
    resources :missing_persons, only: [:index, :show]
    resources :bolos,          only: [:index]
    resources :news,           only: [:index, :show]
    resources :events,         only: [:index, :show]
    get "spotlight", to: "spotlight#index", as: :spotlight
    get "faq",           to: "faq#index",            as: :faq
    post "chat",         to: "chat#message",         as: :chat
    get "officer-login", to: "officer_sessions#new", as: :officer_login
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
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Monitoring routes
  get "/monitoring", to: "monitoring#index", as: :monitoring_index
  get "/monitoring/device/:id", to: "monitoring#device_details", as: :device_monitoring
  post "/monitoring/device/:id/toggle", to: "monitoring#toggle_monitoring", as: :toggle_monitoring
  post "/monitoring/device/:id/reset", to: "monitoring#reset_device", as: :reset_monitoring
  post "/monitoring/device/:id/recalculate", to: "monitoring#recalculate_threshold", as: :recalculate_threshold_monitoring

  # List screens
  resources :mqtt_messages, only: [ :index, :show ] do
    collection do
      get :system
      get :commands
    end
  end
  resources :devices, only: [ :index ]
  resources :readings, only: [ :index ]
  resources :raw_mqtt_messages, only: [ :index, :show ]
  resources :mqtt_topics, only: [ :index, :show ]

  # Admin
  get  "/admin",                 to: "admin#show",            as: :admin
  get  "/admin/confirm_destroy", to: "admin#confirm_destroy", as: :confirm_destroy_admin
  post "/admin/destroy_all",     to: "admin#destroy_all",     as: :destroy_all_admin

  # Background jobs dashboard
  mount GoodJob::Engine => "/good_job"

  # Defines the root path route ("/")
  root to: "dashboard#show"
end

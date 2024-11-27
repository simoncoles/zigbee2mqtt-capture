# Below are the routes for madmin
namespace :madmin do
  resources :devices
  resources :mqtt_messages
  resources :readings
  root to: "dashboard#show"
end

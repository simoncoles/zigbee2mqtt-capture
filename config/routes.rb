# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                                 /assets                                                                                           Propshaft::Server
#                           madmin_devices GET    /madmin/devices(.:format)                                                                         madmin/devices#index
#                                          POST   /madmin/devices(.:format)                                                                         madmin/devices#create
#                        new_madmin_device GET    /madmin/devices/new(.:format)                                                                     madmin/devices#new
#                       edit_madmin_device GET    /madmin/devices/:id/edit(.:format)                                                                madmin/devices#edit
#                            madmin_device GET    /madmin/devices/:id(.:format)                                                                     madmin/devices#show
#                                          PATCH  /madmin/devices/:id(.:format)                                                                     madmin/devices#update
#                                          PUT    /madmin/devices/:id(.:format)                                                                     madmin/devices#update
#                                          DELETE /madmin/devices/:id(.:format)                                                                     madmin/devices#destroy
#                     madmin_mqtt_messages GET    /madmin/mqtt_messages(.:format)                                                                   madmin/mqtt_messages#index
#                                          POST   /madmin/mqtt_messages(.:format)                                                                   madmin/mqtt_messages#create
#                  new_madmin_mqtt_message GET    /madmin/mqtt_messages/new(.:format)                                                               madmin/mqtt_messages#new
#                 edit_madmin_mqtt_message GET    /madmin/mqtt_messages/:id/edit(.:format)                                                          madmin/mqtt_messages#edit
#                      madmin_mqtt_message GET    /madmin/mqtt_messages/:id(.:format)                                                               madmin/mqtt_messages#show
#                                          PATCH  /madmin/mqtt_messages/:id(.:format)                                                               madmin/mqtt_messages#update
#                                          PUT    /madmin/mqtt_messages/:id(.:format)                                                               madmin/mqtt_messages#update
#                                          DELETE /madmin/mqtt_messages/:id(.:format)                                                               madmin/mqtt_messages#destroy
#                          madmin_readings GET    /madmin/readings(.:format)                                                                        madmin/readings#index
#                                          POST   /madmin/readings(.:format)                                                                        madmin/readings#create
#                       new_madmin_reading GET    /madmin/readings/new(.:format)                                                                    madmin/readings#new
#                      edit_madmin_reading GET    /madmin/readings/:id/edit(.:format)                                                               madmin/readings#edit
#                           madmin_reading GET    /madmin/readings/:id(.:format)                                                                    madmin/readings#show
#                                          PATCH  /madmin/readings/:id(.:format)                                                                    madmin/readings#update
#                                          PUT    /madmin/readings/:id(.:format)                                                                    madmin/readings#update
#                                          DELETE /madmin/readings/:id(.:format)                                                                    madmin/readings#destroy
#                              madmin_root GET    /madmin(.:format)                                                                                 madmin/dashboard#show
#                       rails_health_check GET    /up(.:format)                                                                                     rails/health#show
#                       pwa_service_worker GET    /service-worker(.:format)                                                                         rails/pwa#service_worker
#                             pwa_manifest GET    /manifest(.:format)                                                                               rails/pwa#manifest
#                                     root GET    /                                                                                                 madmin/dashboard#show
#         turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#            rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
# new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create

Rails.application.routes.draw do
  draw :madmin
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

  # Defines the root path route ("/")
  root to: "madmin/dashboard#show"
end

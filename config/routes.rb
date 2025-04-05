# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                                 /assets                                                                                           Propshaft::Server
#                              motor_admin        /motor_admin                                                                                      Motor::Admin
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
#                                     root GET    /                                                                                                 motor/ui#show
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
#
# Routes for Motor::Admin:
#                            motor_cable        /cable                                                  #<ActionCable::Server::Base:0x0000ffff83a1cc68 @config=#<ActionCable::Server::Configuration:0x0000ffff83861590 @log_tags=[], @connection_class=#<Proc:0x0000ffff837e0e68 /home/vscode/.rbenv/versions/3.2.5/lib/ruby/gems/3.2.0/gems/actioncable-8.0.2/lib/action_cable/engine.rb:55 (lambda)>, @worker_pool_size=4, @disable_request_forgery_protection=false, @allow_same_origin_as_host=true, @filter_parameters=[:passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc, /\Aio\z/], @health_check_application=#<Proc:0x0000ffff837e3e10 /home/vscode/.rbenv/versions/3.2.5/lib/ruby/gems/3.2.0/gems/actioncable-8.0.2/lib/action_cable/engine.rb:31 (lambda)>, @logger=#<ActiveSupport::BroadcastLogger:0x0000ffff8602d0b0 @broadcasts=[#<ActiveSupport::Logger:0x0000ffff86196eb0 @level=0, @progname=nil, @default_formatter=#<Logger::Formatter:0x0000ffff8602f810 @datetime_format=nil>, @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x0000ffff8602d470 @datetime_format=nil, @thread_key="activesupport_tagged_logging_tags:11560">, @logdev=#<Logger::LogDevice:0x0000ffff842ac130 @shift_period_suffix="%Y%m%d", @shift_size=104857600, @shift_age=1, @filename="/workspaces/zigbee2mqtt-capture/log/development.log", @dev=#<File:/workspaces/zigbee2mqtt-capture/log/development.log>, @binmode=false, @reraise_write_errors=[], @skip_header=false, @mon_data=#<Monitor:0x0000ffff8602f6a8>, @mon_data_owner_object_id=5020>, @level_override={}, @local_level_key=:logger_thread_safe_level_11540>], @progname="Broadcast", @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x0000ffff8602d470 @datetime_format=nil, @thread_key="activesupport_tagged_logging_tags:11560">>, @cable={"adapter"=>"redis", "url"=>"redis://localhost:6379/1"}, @mount_path="/cable", @precompile_assets=true, @allowed_request_origins=/https?:\/\/localhost:\d+/>, @mutex=#<Monitor:0x0000ffff8374a1c0>, @pubsub=nil, @worker_pool=nil, @event_loop=nil, @remote_connections=nil>
#                  motor_api_run_queries POST   /api/run_queries(.:format)                              motor/run_queries#create
#                    motor_api_run_query GET    /api/run_queries/:id(.:format)                          motor/run_queries#show
#                  motor_api_send_alerts POST   /api/send_alerts(.:format)                              motor/send_alerts#create
#                  motor_api_auth_tokens POST   /api/auth_tokens(.:format)                              motor/auth_tokens#create
#                      motor_api_queries GET    /api/queries(.:format)                                  motor/queries#index
#                                        POST   /api/queries(.:format)                                  motor/queries#create
#                        motor_api_query GET    /api/queries/:id(.:format)                              motor/queries#show
#                                        PATCH  /api/queries/:id(.:format)                              motor/queries#update
#                                        PUT    /api/queries/:id(.:format)                              motor/queries#update
#                                        DELETE /api/queries/:id(.:format)                              motor/queries#destroy
#                         motor_api_tags GET    /api/tags(.:format)                                     motor/tags#index
#                      motor_api_configs GET    /api/configs(.:format)                                  motor/configs#index
#                                        POST   /api/configs(.:format)                                  motor/configs#create
#                    motor_api_resources GET    /api/resources(.:format)                                motor/resources#index
#                                        POST   /api/resources(.:format)                                motor/resources#create
#              motor_api_resource_method GET    /api/resource_methods/:resource(.:format)               motor/resource_methods#show
#       motor_api_resource_default_query GET    /api/resource_default_queries/:resource(.:format)       motor/resource_default_queries#show
#                 motor_api_schema_index GET    /api/schema(.:format)                                   motor/schema#index
#                       motor_api_schema GET    /api/schema/:resource(.:format)                         motor/schema#show
#                   motor_api_dashboards GET    /api/dashboards(.:format)                               motor/dashboards#index
#                                        POST   /api/dashboards(.:format)                               motor/dashboards#create
#                    motor_api_dashboard GET    /api/dashboards/:id(.:format)                           motor/dashboards#show
#                                        PATCH  /api/dashboards/:id(.:format)                           motor/dashboards#update
#                                        PUT    /api/dashboards/:id(.:format)                           motor/dashboards#update
#                                        DELETE /api/dashboards/:id(.:format)                           motor/dashboards#destroy
#              motor_api_run_api_request GET    /api/run_api_request(.:format)                          motor/run_api_requests#show
#                                        POST   /api/run_api_request(.:format)                          motor/run_api_requests#create
#          motor_api_run_graphql_request POST   /api/run_graphql_request(.:format)                      motor/run_graphql_requests#create
#                  motor_api_api_configs GET    /api/api_configs(.:format)                              motor/api_configs#index
#                                        POST   /api/api_configs(.:format)                              motor/api_configs#create
#                   motor_api_api_config DELETE /api/api_configs/:id(.:format)                          motor/api_configs#destroy
#                        motor_api_forms GET    /api/forms(.:format)                                    motor/forms#index
#                                        POST   /api/forms(.:format)                                    motor/forms#create
#                         motor_api_form GET    /api/forms/:id(.:format)                                motor/forms#show
#                                        PATCH  /api/forms/:id(.:format)                                motor/forms#update
#                                        PUT    /api/forms/:id(.:format)                                motor/forms#update
#                                        DELETE /api/forms/:id(.:format)                                motor/forms#destroy
#                        motor_api_notes GET    /api/notes(.:format)                                    motor/notes#index
#                                        POST   /api/notes(.:format)                                    motor/notes#create
#                         motor_api_note GET    /api/notes/:id(.:format)                                motor/notes#show
#                                        PATCH  /api/notes/:id(.:format)                                motor/notes#update
#                                        PUT    /api/notes/:id(.:format)                                motor/notes#update
#                                        DELETE /api/notes/:id(.:format)                                motor/notes#destroy
#                    motor_api_note_tags GET    /api/note_tags(.:format)                                motor/note_tags#index
# motor_api_users_for_autocomplete_index GET    /api/users_for_autocomplete(.:format)                   motor/users_for_autocomplete#index
#                motor_api_notifications GET    /api/notifications(.:format)                            motor/notifications#index
#                 motor_api_notification PATCH  /api/notifications/:id(.:format)                        motor/notifications#update
#                                        PUT    /api/notifications/:id(.:format)                        motor/notifications#update
#                    motor_api_reminders POST   /api/reminders(.:format)                                motor/reminders#create
#                     motor_api_reminder DELETE /api/reminders/:id(.:format)                            motor/reminders#destroy
#                       motor_api_alerts GET    /api/alerts(.:format)                                   motor/alerts#index
#                                        POST   /api/alerts(.:format)                                   motor/alerts#create
#                        motor_api_alert GET    /api/alerts/:id(.:format)                               motor/alerts#show
#                                        PATCH  /api/alerts/:id(.:format)                               motor/alerts#update
#                                        PUT    /api/alerts/:id(.:format)                               motor/alerts#update
#                                        DELETE /api/alerts/:id(.:format)                               motor/alerts#destroy
#                        motor_api_icons GET    /api/icons(.:format)                                    motor/icons#index
#   motor_api_active_storage_attachments POST   /api/data/active_storage__attachments(.:format)         motor/active_storage_attachments#create
#                       motor_api_audits GET    /api/audits(.:format)                                   motor/audits#index
#                      motor_api_session GET    /api/session(.:format)                                  motor/sessions#show
#                                        DELETE /api/session(.:format)                                  motor/sessions#destroy
#          motor_api_slack_conversations GET    /api/slack_conversations(.:format)                      motor/slack_conversations#index
#                                        PUT    /api/data/:resource/:resource_id/:method(.:format)      motor/data#execute {:resource_id=>/[^\/]+/}
#   motor_api_resource_association_index GET    /api/data/:resource/:resource_id/:association(.:format) motor/data#index {:resource_id=>/[^\/]+/}
#                                        POST   /api/data/:resource/:resource_id/:association(.:format) motor/data#create {:resource_id=>/[^\/]+/}
#                                        GET    /api/data/:resource(.:format)                           motor/data#index
#                                        POST   /api/data/:resource(.:format)                           motor/data#create
#                     motor_api_resource GET    /api/data/:resource/:id(.:format)                       motor/data#show {:id=>/[^\/]+/}
#                                        PATCH  /api/data/:resource/:id(.:format)                       motor/data#update {:id=>/[^\/]+/}
#                                        PUT    /api/data/:resource/:id(.:format)                       motor/data#update {:id=>/[^\/]+/}
#                                        DELETE /api/data/:resource/:id(.:format)                       motor/data#destroy {:id=>/[^\/]+/}
#                            motor_asset GET    /assets/:filename                                       motor/assets#show {:filename=>/.+/}
#                                  motor GET    /                                                       motor/ui#show
#                          motor_ui_data GET    /data(/*path)(.:format)                                 motor/ui#index
#                 motor_ui_notifications GET    /notifications(.:format)                                motor/ui#index
#                       motor_ui_reports GET    /reports(.:format)                                      motor/ui#index
#                        motor_ui_report GET    /reports/:id(.:format)                                  motor/ui#show
#                       motor_ui_queries GET    /queries(.:format)                                      motor/ui#index
#                     new_motor_ui_query GET    /queries/new(.:format)                                  motor/ui#new
#                         motor_ui_query GET    /queries/:id(.:format)                                  motor/ui#show
#                    motor_ui_dashboards GET    /dashboards(.:format)                                   motor/ui#index
#                 new_motor_ui_dashboard GET    /dashboards/new(.:format)                               motor/ui#new
#                     motor_ui_dashboard GET    /dashboards/:id(.:format)                               motor/ui#show
#                        motor_ui_alerts GET    /alerts(.:format)                                       motor/ui#index
#                     new_motor_ui_alert GET    /alerts/new(.:format)                                   motor/ui#new
#                         motor_ui_alert GET    /alerts/:id(.:format)                                   motor/ui#show
#                         motor_ui_forms GET    /forms(.:format)                                        motor/ui#index
#                      new_motor_ui_form GET    /forms/new(.:format)                                    motor/ui#new
#                          motor_ui_form GET    /forms/:id(.:format)                                    motor/ui#show

Rails.application.routes.draw do
  mount Motor::Admin => "/motor_admin"
  draw :madmin
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root to: "motor/ui#show"
end

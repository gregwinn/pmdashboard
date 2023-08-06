Pmdashboard::Application.configure do
  config.to_prepare do
    Devise::SessionsController.layout       "basic"
    Devise::RegistrationsController.layout  proc{ |controller| user_signed_in? ? "application" : "basic" }
  end
end
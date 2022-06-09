class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout 'application', except: [:sign_up, :sign_in]

  GRAND_SLAM_ROUND_POINTS = {
    round_of_128: 50,
    round_of_64: 60,
    round_of_32: 80,
    round_of_16: 200,
    quarterfinal: 500,
    semifinal: 1000,
    final: 2500
  }

  BONUS_MULTIPLICATOR = {
    pos1: 10,
    pos2: 8,
    pos3: 6,
    pos4: 4,
    pos5: 2,
    pos6: 1,
    pos7: 1,
    pos8: 1,
    pos0: 0
  }

  ATP_1000_ROUND_POINTS = {
    round_of_64: 20,
    round_of_32: 60,
    round_of_16: 80,
    quarterfinal: 250,
    semifinal: 500,
    final: 1000
  }

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end
end

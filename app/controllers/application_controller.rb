class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  skip_before_action :verify_authenticity_token

  private

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(access_token: token)
    end
  end

  def after_sign_in_path_for(devise)
    root_path
  end

  def after_sign_out_path_for(devise)
    new_admin_session_path
  end
end

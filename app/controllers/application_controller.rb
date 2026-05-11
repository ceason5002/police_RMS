class ApplicationController < ActionController::Base
  include Auditable

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :authenticate_user!

  # After sign-in, go to admin if admin, else main site
  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
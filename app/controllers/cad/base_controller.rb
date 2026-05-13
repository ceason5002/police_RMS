module Cad
  class BaseController < ApplicationController
    layout "cad"
    before_action :authenticate_user!
    before_action :require_cad_access!

    private

    def require_cad_access!
      unless current_user.cad_access?
        redirect_to root_path, alert: "CAD access requires dispatcher or supervisor role."
      end
    end
  end
end

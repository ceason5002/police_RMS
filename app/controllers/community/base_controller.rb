module Community
  class BaseController < ApplicationController
    layout "community"
    skip_before_action :authenticate_user!
    include Pagy::Method
  end
end

class Admin::SpotlightsController < Admin::BaseController
  def index
    @officers = Officer.order(:last_name)
    @featured = Officer.featured.first
  end

  def update
    Officer.update_all(featured: false, spotlight_bio: nil)
    officer = Officer.find(params[:id])
    officer.update!(featured: true, spotlight_bio: params[:spotlight_bio])
    redirect_to admin_spotlights_path, notice: "#{officer.full_name} set as Officer of the Month."
  end
end

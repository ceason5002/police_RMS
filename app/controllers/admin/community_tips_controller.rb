class Admin::CommunityTipsController < Admin::BaseController
  before_action :set_tip, only: [:show, :review, :close]

  def index
    scope = params[:status].present? ? CommunityTip.where(status: params[:status]) : CommunityTip.all
    @tips = scope.recent
  end

  def show; end

  def review
    @tip.update!(status: "Under Review")
    redirect_to admin_community_tip_path(@tip), notice: "Marked as Under Review."
  end

  def close
    @tip.update!(status: "Closed")
    redirect_to admin_community_tip_path(@tip), notice: "Tip closed."
  end

  private

  def set_tip
    @tip = CommunityTip.find(params[:id])
  end
end

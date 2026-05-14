class Admin::AlertSubscriptionsController < Admin::BaseController
  def index
    @subscriptions = AlertSubscription.order(created_at: :desc)
  end

  def destroy
    AlertSubscription.find(params[:id]).destroy
    redirect_to admin_alert_subscriptions_path, notice: "Subscription removed."
  end
end

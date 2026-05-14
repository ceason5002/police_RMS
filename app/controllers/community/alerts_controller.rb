module Community
  class AlertsController < BaseController
    def new
      @subscription = AlertSubscription.new
    end

    def create
      @subscription = AlertSubscription.new(subscription_params)
      if @subscription.save
        AlertMailer.confirmation(@subscription).deliver_later
        redirect_to community_root_path,
          notice: "Check your inbox — we sent a confirmation email to #{@subscription.email}."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      sub = AlertSubscription.find_by(token: params[:id])
      sub&.destroy
      redirect_to community_root_path, notice: "You have been unsubscribed from crime alerts."
    end

    private

    def subscription_params
      params.require(:alert_subscription).permit(:email, :zip_code)
    end
  end
end

class AlertMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM", "noreply@policedept.local")

  def confirmation(subscription)
    @subscription = subscription
    @unsubscribe_url = community_alerts_url(@subscription.token, host: default_url_options[:host])
    mail(to: @subscription.email, subject: "Confirm your crime alert subscription")
  end

  def crime_alert(subscription, incident)
    @subscription = subscription
    @incident     = incident
    @unsubscribe_url = community_alerts_url(@subscription.token, host: default_url_options[:host])
    mail(to: @subscription.email, subject: "Crime Alert: #{incident.incident_type} in #{incident.city}")
  end
end

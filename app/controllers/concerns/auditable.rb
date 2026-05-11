module Auditable
  extend ActiveSupport::Concern

  def audit(action, resource, details: nil)
    AuditLog.record(
      user:     current_user,
      action:   action,
      resource: resource,
      details:  details,
      ip:       request.remote_ip
    )
  rescue StandardError
    # never let audit failure break the request
  end
end
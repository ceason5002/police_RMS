class AuditLog < ApplicationRecord
  belongs_to :user, optional: true

  scope :recent, -> { order(created_at: :desc) }

  def self.record(user:, action:, resource:, details: nil, ip: nil)
    create!(
      user_id:       user&.id,
      action:        action,
      resource_type: resource.class.name,
      resource_id:   resource.id,
      details:       details,
      ip_address:    ip
    )
  end
end
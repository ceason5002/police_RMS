class FleetLog < ApplicationRecord
  LOG_TYPES = ["Mileage Check", "Maintenance", "Fuel", "Damage", "Inspection", "Other"].freeze

  belongs_to :fleet_vehicle

  validates :log_type, inclusion: { in: LOG_TYPES }
  validates :description, presence: true
  validates :logged_at, presence: true

  scope :recent, -> { order(logged_at: :desc) }
end

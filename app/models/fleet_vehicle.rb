class FleetVehicle < ApplicationRecord
  STATUSES = ["Active", "Out of Service", "Retired"].freeze

  has_many :fleet_logs, dependent: :destroy

  validates :unit_number, presence: true, uniqueness: true
  validates :make, :model, presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 1900 }
  validates :status, inclusion: { in: STATUSES }

  scope :active,  -> { where(status: "Active") }
  scope :ordered, -> { order(:unit_number) }

  def display_name
    "#{year} #{make} #{model} (#{unit_number})"
  end
end

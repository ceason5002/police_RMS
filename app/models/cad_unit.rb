class CadUnit < ApplicationRecord
  STATUSES   = ["Available", "Dispatched", "On Scene", "Out of Service", "Off Duty"].freeze
  UNIT_TYPES = ["Patrol", "K9", "Detective", "Supervisor", "Traffic", "SWAT"].freeze

  belongs_to :assigned_officer, class_name: "Officer", optional: true
  has_many   :call_units,       dependent: :destroy
  has_many   :cad_calls,        through: :call_units
  has_many   :unit_status_logs, dependent: :destroy

  validates :unit_number, presence: true, uniqueness: true
  validates :unit_type,   presence: true, inclusion: { in: UNIT_TYPES }
  validates :status,      presence: true, inclusion: { in: STATUSES }

  scope :available,    -> { where(status: "Available") }
  scope :active_duty,  -> { where.not(status: "Off Duty") }
  scope :by_number,    -> { order(:unit_number) }

  def available? = status == "Available"

  def status_badge_class
    case status
    when "Available"      then "badge-green"
    when "Dispatched"     then "badge-yellow"
    when "On Scene"       then "badge-blue"
    when "Out of Service" then "badge-red"
    when "Off Duty"       then "badge-gray"
    end
  end

  def change_status!(new_status, changed_by: nil)
    update!(status: new_status)
    unit_status_logs.create!(
      status:     new_status,
      changed_by: changed_by,
      changed_at: Time.current
    )
  end
end

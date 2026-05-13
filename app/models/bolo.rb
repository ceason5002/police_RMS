class Bolo < ApplicationRecord
  STATUSES = ["Active", "Cancelled", "Resolved"].freeze

  belongs_to :issuing_officer, class_name: "Officer", optional: true
  belongs_to :created_by,      class_name: "User",    optional: true

  validates :status, presence: true, inclusion: { in: STATUSES }
  validate  :must_have_description

  scope :active, -> { where(status: "Active") }
  scope :recent, -> { order(created_at: :desc) }

  def active?    = status == "Active"
  def cancelled? = status == "Cancelled"
  def resolved?  = status == "Resolved"

  def status_badge_class
    case status
    when "Active"    then "badge-red"
    when "Cancelled" then "badge-gray"
    when "Resolved"  then "badge-green"
    end
  end

  def summary
    parts = []
    parts << subject_description.truncate(60) if subject_description.present?
    parts << vehicle_description.truncate(40) if vehicle_description.present?
    parts.join(" / ")
  end

  private

  def must_have_description
    if subject_description.blank? && vehicle_description.blank?
      errors.add(:base, "Must provide subject or vehicle description")
    end
  end
end

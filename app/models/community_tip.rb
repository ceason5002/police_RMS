class CommunityTip < ApplicationRecord
  TIP_TYPES = [
    "Drug Activity", "Gang Activity", "Wanted Person",
    "Theft / Robbery", "Vandalism", "Missing Person",
    "Suspicious Activity", "Other"
  ].freeze

  STATUSES = ["New", "Under Review", "Acted Upon", "Closed"].freeze

  validates :tip_type,    presence: true, inclusion: { in: TIP_TYPES }
  validates :description, presence: true
  validates :status,      presence: true, inclusion: { in: STATUSES }

  scope :open,   -> { where.not(status: "Closed") }
  scope :recent, -> { order(created_at: :desc) }

  def new? = status == "New"
end

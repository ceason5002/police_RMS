class CommunityRequest < ApplicationRecord
  REQUEST_TYPES = [
    "Noise Complaint", "Abandoned Vehicle", "Graffiti",
    "Suspicious Activity", "Pothole / Road Hazard",
    "Welfare Check Request", "Other"
  ].freeze

  STATUSES = ["New", "Under Review", "Assigned", "Resolved", "Closed"].freeze

  belongs_to :incident, optional: true
  has_one_attached :photo

  validates :request_type, presence: true, inclusion: { in: REQUEST_TYPES }
  validates :description,  presence: true
  validates :location,     presence: true
  validates :status,       presence: true, inclusion: { in: STATUSES }
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  scope :open,   -> { where.not(status: ["Resolved", "Closed"]) }
  scope :recent, -> { order(created_at: :desc) }

  def new?      = status == "New"
  def resolved? = status == "Resolved"
end

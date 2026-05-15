class OfficerComplaint < ApplicationRecord
  COMPLAINT_TYPES = ["Use of Force", "Misconduct", "Rudeness / Unprofessional Conduct",
                     "Discrimination", "Procedure Violation", "Excessive Delay",
                     "Other"].freeze
  STATUSES = ["New", "Under Investigation", "Sustained", "Not Sustained",
              "Exonerated", "Unfounded", "Closed"].freeze

  belongs_to :officer, optional: true

  validates :complaint_type, inclusion: { in: COMPLAINT_TYPES }
  validates :description, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :received_at, presence: true

  before_validation :set_received_at, on: :create

  scope :recent, -> { order(received_at: :desc) }
  scope :open,   -> { where(status: ["New", "Under Investigation"]) }

  private

  def set_received_at
    self.received_at ||= Time.current
  end
end

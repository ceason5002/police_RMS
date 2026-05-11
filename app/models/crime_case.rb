class CrimeCase < ApplicationRecord
  belongs_to :lead_officer, class_name: "Officer", optional: true
  has_many :incidents, foreign_key: :crime_case_id, dependent: :nullify

  STATUSES = ["Open", "Under Investigation", "Closed", "Cold"].freeze

  validates :case_number, presence: true, uniqueness: true
  validates :title,       presence: true
  validates :status,      presence: true, inclusion: { in: STATUSES }

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= "Open"
  end
end
class Incident < ApplicationRecord
  has_many :arrests, dependent: :destroy
  has_many :evidences, dependent: :destroy
  validates :report_number, presence: true, uniqueness: true
  validates :incident_type, presence: true
  validates :status, presence: true, inclusion: { in: ["Open", "Closed", "Under Investigation"] }
  validates :occurred_at, presence: true
  validates :street_address, presence: true
end

class Incident < ApplicationRecord
  belongs_to :crime_case, optional: true
  has_one    :cad_call,   dependent: :nullify
  has_many   :arrests,    dependent: :destroy
  has_many   :evidences,  dependent: :destroy
  validates :report_number, presence: true, uniqueness: true
  validates :incident_type, presence: true
  validates :status, presence: true, inclusion: { in: ["Open", "Closed", "Under Investigation"] }
  validates :occurred_at, presence: true
  validates :street_address, presence: true

  INCIDENT_TYPES = ["Assault", "Burglary", "Disorderly Conduct", "Domestic Violence",
                    "Drug Offense", "Fraud", "Homicide", "Missing Person",
                    "Motor Vehicle Theft", "Robbery", "Theft", "Traffic Accident",
                    "Trespassing", "Vandalism", "Other"].freeze

  after_create :send_crime_alerts

  private

  def send_crime_alerts
    return unless zip_code.present?
    AlertSubscription.confirmed.where(zip_code: zip_code).find_each do |sub|
      AlertMailer.crime_alert(sub, self).deliver_later
    end
  end
end

class OfficerTraining < ApplicationRecord
  TRAINING_TYPES = ["Firearms", "Use of Force", "First Aid / CPR", "Legal Updates",
                    "De-escalation", "Defensive Driving", "Cybersecurity",
                    "Crisis Intervention", "Community Relations", "Other"].freeze
  STATUSES = ["Scheduled", "Completed", "Expired", "Waived"].freeze

  belongs_to :officer

  validates :training_type, inclusion: { in: TRAINING_TYPES }
  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :recent,     -> { order(created_at: :desc) }
  scope :expiring,   -> { where(status: "Completed").where("expires_on <= ?", 30.days.from_now) }
  scope :by_officer, ->(id) { where(officer_id: id) }
end

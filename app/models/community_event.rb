class CommunityEvent < ApplicationRecord
  EVENT_TYPES = [
    "Community Meeting", "Neighborhood Watch", "Recruitment",
    "Training / Safety", "Youth Program", "General"
  ].freeze

  validates :title,      presence: true
  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
  validates :starts_at,  presence: true

  scope :published,   -> { where(published: true) }
  scope :upcoming,    -> { published.where("starts_at >= ?", Time.current).order(:starts_at) }
  scope :past,        -> { published.where("starts_at < ?", Time.current).order(starts_at: :desc) }
end

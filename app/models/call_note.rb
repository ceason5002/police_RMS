class CallNote < ApplicationRecord
  belongs_to :cad_call
  belongs_to :user, optional: true

  validates :body, presence: true

  scope :chronological, -> { order(created_at: :asc) }
end

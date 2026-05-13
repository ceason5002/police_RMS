class UnitStatusLog < ApplicationRecord
  belongs_to :cad_unit
  belongs_to :changed_by, class_name: "User", optional: true

  validates :status,     presence: true
  validates :changed_at, presence: true

  scope :recent, -> { order(changed_at: :desc) }
end

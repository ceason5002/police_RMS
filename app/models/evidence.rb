class Evidence < ApplicationRecord
  belongs_to :incident
  validates :evidence_number, presence: true, uniqueness: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: ["Collected", "In Lab", "In Storage", "Released", "Destroyed"] }

  STATUSES = ["Collected", "In Lab", "In Storage", "Released", "Destroyed"].freeze
end

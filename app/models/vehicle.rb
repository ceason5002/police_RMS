class Vehicle < ApplicationRecord
  belongs_to :person
  validates :plate_number, presence: true
  validates :make, presence: true
  validates :model, presence: true
end

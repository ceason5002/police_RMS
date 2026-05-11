class Unit < ApplicationRecord
  has_many :officer_units, dependent: :destroy
  has_many :officers, through: :officer_units

  TYPES = ["Patrol", "Homicide", "Narcotics", "Gang Task Force", "Traffic",
           "K-9", "SWAT", "Detective Bureau", "Juvenile", "Community Policing",
           "Internal Affairs", "Cybercrime"].freeze

  validates :name, presence: true, uniqueness: true
  validates :unit_type, presence: true
end
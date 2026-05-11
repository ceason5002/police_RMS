class Officer < ApplicationRecord
  validates :badge_number, presence: true, uniqueness: true
  validates :first_name, :last_name, :rank, presence: true

  RANKS = ["Officer", "Senior Officer", "Detective", "Corporal", "Sergeant", "Lieutenant", "Captain", "Commander", "Deputy Chief", "Chief"].freeze
end

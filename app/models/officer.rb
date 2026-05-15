class Officer < ApplicationRecord
  has_many :officer_units, dependent: :destroy
  has_many :units, through: :officer_units
  has_many :led_cases, class_name: "CrimeCase", foreign_key: :lead_officer_id
  has_one  :user, dependent: :nullify
  has_many :officer_trainings, dependent: :destroy
  has_many :officer_complaints, dependent: :nullify

  validates :badge_number, presence: true, uniqueness: true
  validates :first_name, :last_name, :rank, presence: true

  RANKS = ["Officer", "Senior Officer", "Detective", "Corporal", "Sergeant", "Lieutenant", "Captain", "Commander", "Deputy Chief", "Chief"].freeze

  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :featured, -> { where(featured: true) }

  def full_name     = "#{first_name} #{last_name}"
  def featured?     = self[:featured]
  def has_spotlight? = featured? && spotlight_bio.present?
end

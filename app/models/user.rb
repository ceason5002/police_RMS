class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[admin detective patrol_officer].freeze

  belongs_to :officer, optional: true
  has_many :audit_logs, foreign_key: :user_id

  validates :role, inclusion: { in: ROLES }, allow_blank: false
  before_validation :set_default_role

  scope :active, -> { where(active: true) }

  def admin?          = role == "admin"
  def detective?      = role == "detective"
  def patrol_officer? = role == "patrol_officer"

  def display_role
    role&.humanize
  end

  def display_name
    officer.present? ? "#{officer.first_name} #{officer.last_name}" : email
  end

  private

  def set_default_role
    self.role ||= "patrol_officer"
    self.active = true if active.nil?
  end
end
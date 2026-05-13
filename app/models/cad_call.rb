class CadCall < ApplicationRecord
  STATUSES = ["Pending", "Dispatched", "On Scene", "Cleared"].freeze

  CALL_TYPES = [
    "Robbery", "Assault", "Burglary", "Vehicle Theft", "Homicide",
    "Domestic Violence", "Traffic Accident", "Medical Emergency",
    "Suspicious Activity", "Drug Activity", "Noise Complaint",
    "Theft", "Vandalism", "Trespassing", "Welfare Check",
    "Shots Fired", "Missing Person", "DUI", "Disturbance", "Other"
  ].freeze

  PRIORITIES = {
    1 => "Priority 1 — Life Threatening",
    2 => "Priority 2 — Serious Crime",
    3 => "Priority 3 — Moderate",
    4 => "Priority 4 — Non-Urgent",
    5 => "Priority 5 — Information Only"
  }.freeze

  PRIORITY_CSS = {
    1 => "priority-1",
    2 => "priority-2",
    3 => "priority-3",
    4 => "priority-4",
    5 => "priority-5"
  }.freeze

  belongs_to :incident,   optional: true
  belongs_to :created_by, class_name: "User", optional: true
  has_many   :call_units, dependent: :destroy
  has_many   :cad_units,  through: :call_units
  has_many   :call_notes, dependent: :destroy

  validates :call_number, presence: true, uniqueness: true
  validates :location,    presence: true
  validates :call_type,   presence: true
  validates :priority,    presence: true, inclusion: { in: 1..5 }
  validates :status,      presence: true, inclusion: { in: STATUSES }
  validates :received_at, presence: true

  scope :active,       -> { where.not(status: "Cleared") }
  scope :cleared,      -> { where(status: "Cleared") }
  scope :by_priority,  -> { order(priority: :asc, received_at: :asc) }

  before_validation :generate_call_number, on: :create

  def pending?    = status == "Pending"
  def dispatched? = status == "Dispatched"
  def on_scene?   = status == "On Scene"
  def cleared?    = status == "Cleared"

  def priority_label     = PRIORITIES[priority]
  def priority_css_class = PRIORITY_CSS[priority]

  def advance_status!
    case status
    when "Pending"
      update!(status: "Dispatched", dispatched_at: Time.current)
    when "Dispatched"
      update!(status: "On Scene", on_scene_at: Time.current)
    when "On Scene"
      update!(status: "Cleared", cleared_at: Time.current)
      cad_units.each { |u| u.update!(status: "Available") }
    end
  end

  def response_time_minutes
    return nil unless received_at && dispatched_at
    ((dispatched_at - received_at) / 60).round(1)
  end

  def on_scene_time_minutes
    return nil unless dispatched_at && on_scene_at
    ((on_scene_at - dispatched_at) / 60).round(1)
  end

  def self.generate_call_number
    today = Date.today.strftime("%Y%m%d")
    last  = where("call_number LIKE ?", "CAD-#{today}-%").order(:call_number).last
    seq   = last ? last.call_number.split("-").last.to_i + 1 : 1
    "CAD-#{today}-#{seq.to_s.rjust(4, '0')}"
  end

  private

  def generate_call_number
    self.call_number ||= self.class.generate_call_number
  end
end

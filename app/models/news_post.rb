class NewsPost < ApplicationRecord
  STATUSES = ["Draft", "Published"].freeze

  validates :title,  presence: true
  validates :body,   presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :published, -> { where(status: "Published").order(published_at: :desc) }
  scope :recent,    -> { order(created_at: :desc) }

  before_save :set_published_at

  def published? = status == "Published"
  def draft?     = status == "Draft"

  private

  def set_published_at
    if status == "Published" && published_at.nil?
      self.published_at = Time.current
    end
  end
end

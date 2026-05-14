class AlertSubscription < ApplicationRecord
  before_validation :generate_token, on: :create

  validates :email,    presence: true, uniqueness: true,
                       format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :zip_code, presence: true, format: { with: /\A\d{5}\z/, message: "must be a 5-digit ZIP code" }
  validates :token,    presence: true

  scope :confirmed, -> { where(confirmed: true) }

  def confirm!
    update!(confirmed: true)
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end
end

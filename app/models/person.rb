class Person < ApplicationRecord
  has_many :arrests, dependent: :nullify
  has_many :vehicles, dependent: :nullify
  validates :first_name, :last_name, presence: true

  def full_name
    "#{last_name}, #{first_name}"
  end
end

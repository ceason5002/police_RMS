class Arrest < ApplicationRecord
  belongs_to :incident
  belongs_to :person
  has_one_attached :mugshot
end

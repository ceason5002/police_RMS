class CallUnit < ApplicationRecord
  belongs_to :cad_call
  belongs_to :cad_unit

  validates :assigned_at,  presence: true
  validates :cad_unit_id, uniqueness: { scope: :cad_call_id, message: "already assigned to this call" }
end

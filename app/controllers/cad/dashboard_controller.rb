module Cad
  class DashboardController < BaseController
    def index
      @active_calls  = CadCall.active.includes(:cad_units, :call_notes).by_priority
      @units         = CadUnit.includes(:assigned_officer).by_number
      @active_bolos  = Bolo.active.order(created_at: :desc)
      @stats = {
        active_calls:      CadCall.active.count,
        pending_calls:     CadCall.where(status: "Pending").count,
        available_units:   CadUnit.available.count,
        active_bolos:      Bolo.active.count,
        cleared_today:     CadCall.where(status: "Cleared").where("cleared_at >= ?", Time.current.beginning_of_day).count
      }
    end
  end
end

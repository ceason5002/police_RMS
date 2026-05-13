module Cad
  class ReportsController < BaseController
    def index
      @today_stats = {
        total:      CadCall.where("received_at >= ?", Time.current.beginning_of_day).count,
        cleared:    CadCall.where("received_at >= ?", Time.current.beginning_of_day).where(status: "Cleared").count,
        active:     CadCall.active.count,
        bolos:      Bolo.active.count
      }
    end

    def call_history
      @calls = CadCall.includes(:cad_units, :created_by).order(received_at: :desc)
      @calls = @calls.where("received_at >= ?", Date.parse(params[:from]).beginning_of_day) if params[:from].present?
      @calls = @calls.where("received_at <= ?", Date.parse(params[:to]).end_of_day)         if params[:to].present?
      @calls = @calls.where(status: params[:status])       if params[:status].present?
      @calls = @calls.where(call_type: params[:call_type]) if params[:call_type].present?
      if params[:unit].present?
        unit = CadUnit.find_by(unit_number: params[:unit])
        @calls = @calls.joins(:call_units).where(call_units: { cad_unit_id: unit.id }) if unit
      end
      @calls = @calls.limit(500)
    end

    def response_times
      @calls = CadCall.where.not(dispatched_at: nil).includes(:cad_units).order(received_at: :desc)
      @calls = @calls.where("received_at >= ?", Date.parse(params[:from]).beginning_of_day) if params[:from].present?
      @calls = @calls.where("received_at <= ?", Date.parse(params[:to]).end_of_day)         if params[:to].present?
      @calls = @calls.limit(500)

      times = @calls.map(&:response_time_minutes).compact
      @avg_response_time   = times.any? ? (times.sum / times.size).round(1) : nil
      @min_response_time   = times.min&.round(1)
      @max_response_time   = times.max&.round(1)
      @median_response_time = times.any? ? times.sort[times.size / 2].round(1) : nil
    end

    def shift_summary
      @date            = params[:date].present? ? Date.parse(params[:date]) : Date.today
      start_of_day     = @date.beginning_of_day
      end_of_day       = @date.end_of_day

      day_calls = CadCall.where(received_at: start_of_day..end_of_day)

      @total_calls   = day_calls.count
      @cleared_calls = day_calls.where(status: "Cleared").count
      @priority_breakdown = day_calls.group(:priority).count.sort
      @type_breakdown     = day_calls.group(:call_type).count.sort_by { |_, v| -v }.first(10)

      @by_dispatcher = day_calls.includes(:created_by)
        .group_by { |c| c.created_by&.display_name || "System" }
        .transform_values(&:count)
        .sort_by { |_, v| -v }
    end

    def audit_trail
      @logs = UnitStatusLog.includes(:cad_unit, :changed_by).order(changed_at: :desc)
      @logs = @logs.where("changed_at >= ?", Date.parse(params[:from]).beginning_of_day) if params[:from].present?
      @logs = @logs.where("changed_at <= ?", Date.parse(params[:to]).end_of_day)         if params[:to].present?
      if params[:unit].present?
        unit = CadUnit.find_by(unit_number: params[:unit])
        @logs = @logs.where(cad_unit: unit) if unit
      end
      @logs = @logs.limit(300)
    end
  end
end

module Cad
  class CallsController < BaseController
    before_action :set_call, only: [
      :show, :edit, :update, :destroy,
      :add_note, :assign_unit, :remove_unit, :advance_status, :send_to_rms
    ]

    def index
      @calls = CadCall.includes(:cad_units, :created_by).order(received_at: :desc)
      @calls = @calls.where(status: params[:status])       if params[:status].present?
      @calls = @calls.where(priority: params[:priority])   if params[:priority].present?
      @calls = @calls.where(call_type: params[:call_type]) if params[:call_type].present?
      if params[:q].present?
        q = "%#{params[:q]}%"
        @calls = @calls.where("location LIKE ? OR call_type LIKE ? OR call_number LIKE ?", q, q, q)
      end
    end

    def show
      @notes          = @call.call_notes.chronological.includes(:user)
      @assigned_units = @call.cad_units.includes(:assigned_officer)
      @available_units = CadUnit.available.where.not(id: @assigned_units.map(&:id)).includes(:assigned_officer)
    end

    def new
      @call = CadCall.new(received_at: Time.current, priority: 3, status: "Pending")
    end

    def create
      @call = CadCall.new(call_params)
      @call.created_by = current_user
      @call.received_at ||= Time.current

      if @call.save
        redirect_to cad_call_path(@call), notice: "Call #{@call.call_number} created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @call.update(call_params)
        redirect_to cad_call_path(@call), notice: "Call updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @call.destroy
      redirect_to cad_calls_path, notice: "Call #{@call.call_number} removed."
    end

    def advance_status
      if @call.cleared?
        redirect_to cad_call_path(@call), alert: "Call is already cleared."
      else
        old = @call.status
        @call.advance_status!
        redirect_to cad_call_path(@call), notice: "Status advanced: #{old} → #{@call.status}."
      end
    end

    def add_note
      note = @call.call_notes.build(body: params[:body], user: current_user)
      if note.save
        redirect_to cad_call_path(@call), notice: "Note added."
      else
        redirect_to cad_call_path(@call), alert: "Note cannot be blank."
      end
    end

    def assign_unit
      unit = CadUnit.find(params[:cad_unit_id])

      if CallUnit.exists?(cad_call: @call, cad_unit: unit)
        redirect_to cad_call_path(@call), alert: "#{unit.unit_number} is already assigned to this call."
        return
      end

      CallUnit.create!(cad_call: @call, cad_unit: unit, assigned_at: Time.current)
      unit.change_status!("Dispatched", changed_by: current_user)
      @call.update!(status: "Dispatched", dispatched_at: Time.current) if @call.pending?
      redirect_to cad_call_path(@call), notice: "#{unit.unit_number} assigned."
    end

    def remove_unit
      unit = CallUnit.find_by(cad_call: @call, cad_unit_id: params[:cad_unit_id])
      if unit
        cad_unit = unit.cad_unit
        unit.destroy
        cad_unit.change_status!("Available", changed_by: current_user)
        redirect_to cad_call_path(@call), notice: "#{cad_unit.unit_number} released."
      else
        redirect_to cad_call_path(@call), alert: "Unit not found on this call."
      end
    end

    def send_to_rms
      unless @call.cleared?
        redirect_to cad_call_path(@call), alert: "Only cleared calls can be sent to RMS."
        return
      end

      if @call.incident.present?
        redirect_to incident_path(@call.incident),
          notice: "Already linked to RMS incident #{@call.incident.report_number}."
        return
      end

      rms_number = @call.call_number.sub("CAD-", "INC-")

      incident = Incident.new(
        report_number:  rms_number,
        incident_type:  @call.call_type,
        status:         "Open",
        street_address: @call.location,
        latitude:       @call.latitude,
        longitude:      @call.longitude,
        occurred_at:    @call.received_at,
        reported_at:    @call.received_at,
        narrative:      build_narrative(@call)
      )

      if incident.save
        @call.update!(incident: incident)
        redirect_to incident_path(incident),
          notice: "RMS Incident #{incident.report_number} created from #{@call.call_number}."
      else
        redirect_to cad_call_path(@call),
          alert: "Could not create RMS incident: #{incident.errors.full_messages.to_sentence}."
      end
    end

    def active_calls_data
      calls = CadCall.active.includes(:cad_units).by_priority
      render json: calls.map { |c|
        {
          id:          c.id,
          call_number: c.call_number,
          call_type:   c.call_type,
          priority:    c.priority,
          status:      c.status,
          location:    c.location,
          latitude:    c.latitude,
          longitude:   c.longitude,
          received_at: c.received_at,
          units:       c.cad_units.map(&:unit_number)
        }
      }
    end

    private

    def set_call
      @call = CadCall.find(params[:id])
    end

    def call_params
      params.require(:cad_call).permit(
        :caller_name, :caller_phone, :location, :latitude, :longitude,
        :call_type, :priority, :description, :status, :received_at
      )
    end

    def build_narrative(call)
      lines = [
        "=== DISPATCH LOG: #{call.call_number} ===",
        "Call Type:    #{call.call_type}",
        "Priority:     #{call.priority_label}",
        "Location:     #{call.location}",
      ]
      lines << "Caller:       #{[call.caller_name, call.caller_phone].compact.join(' — ')}" if call.caller_name.present? || call.caller_phone.present?
      lines << "Description:  #{call.description}" if call.description.present?
      lines << ""
      lines << "Units:        #{call.cad_units.map(&:unit_number).join(', ')}" if call.cad_units.any?
      lines << "Received:     #{call.received_at&.strftime('%Y-%m-%d %H:%M')}"
      lines << "Dispatched:   #{call.dispatched_at&.strftime('%H:%M')}" if call.dispatched_at
      lines << "On Scene:     #{call.on_scene_at&.strftime('%H:%M')}"   if call.on_scene_at
      lines << "Cleared:      #{call.cleared_at&.strftime('%H:%M')}"    if call.cleared_at
      unless call.call_notes.empty?
        lines << ""
        lines << "=== NOTES ==="
        call.call_notes.chronological.each do |note|
          lines << "[#{note.created_at.strftime('%H:%M')}] #{note.body}"
        end
      end
      lines.join("\n")
    end
  end
end

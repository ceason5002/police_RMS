module Community
  class MissingPersonsController < BaseController
    def index
      @cases = Incident.where(incident_type: "Missing Person", status: "Open")
                       .order(occurred_at: :desc)
    end

    def show
      @incident = Incident.where(incident_type: "Missing Person").find(params[:id])
    end
  end
end

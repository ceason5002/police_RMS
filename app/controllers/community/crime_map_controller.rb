module Community
  class CrimeMapController < BaseController
    FUZZ = 0.004 # ~400m coordinate jitter for anonymization

    def index
      @incident_types = Incident::INCIDENT_TYPES
    end

    def data
      scope = Incident.where("occurred_at >= ?", 90.days.ago)
                      .where.not(latitude: nil, longitude: nil)

      scope = scope.where(incident_type: params[:type]) if params[:type].present?

      if params[:days].present?
        scope = scope.where("occurred_at >= ?", params[:days].to_i.days.ago)
      end

      incidents = scope.select(:id, :incident_type, :status, :city, :state, :latitude, :longitude, :occurred_at)

      render json: incidents.map { |inc|
        {
          id:            inc.id,
          incident_type: inc.incident_type,
          status:        inc.status,
          area:          "#{inc.city}, #{inc.state}",
          occurred_at:   inc.occurred_at.strftime("%b %-d, %Y"),
          lat:           (inc.latitude  + rand(-FUZZ..FUZZ)).round(5),
          lng:           (inc.longitude + rand(-FUZZ..FUZZ)).round(5)
        }
      }
    end
  end
end

json.extract! incident, :id, :report_number, :incident_type, :status, :location, :occurred_at, :reported_at, :narrative, :created_at, :updated_at
json.url incident_url(incident, format: :json)

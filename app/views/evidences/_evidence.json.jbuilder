json.extract! evidence, :id, :incident_id, :evidence_number, :description, :status, :location_stored, :chain_of_custody, :collected_at, :collected_by, :created_at, :updated_at
json.url evidence_url(evidence, format: :json)

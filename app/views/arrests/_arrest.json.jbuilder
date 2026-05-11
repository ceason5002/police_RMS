json.extract! arrest, :id, :incident_id, :person_id, :charges, :arrested_at, :created_at, :updated_at
json.url arrest_url(arrest, format: :json)

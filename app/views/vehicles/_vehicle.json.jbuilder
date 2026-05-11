json.extract! vehicle, :id, :plate_number, :make, :model, :year, :color, :person_id, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)

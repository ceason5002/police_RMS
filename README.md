# Police RMS

A Records Management System for law enforcement built with Ruby on Rails 8.1.

## Requirements

- Ruby 3.2+
- Rails 8.1.3
- SQLite3

## Setup

```bash
bundle install
rails db:create db:migrate
rails server
```

Then open `http://127.0.0.1:3000`.

## Windows Note

The default Puma `tmp_restart` plugin does not work on Windows. It has been removed from `config/puma.rb`. Use `rails server` normally — do not use `bin/rails server` directly.

---

## Modules

### Incidents
Core report record. Fields: report number, incident type, status, street address, city, state, ZIP code, latitude/longitude, occurred at, reported at, narrative.

- Incident type is a dropdown (Assault, Burglary, Domestic Violence, Drug Offense, Fraud, Homicide, Missing Person, Motor Vehicle Theft, Robbery, Theft, Traffic Accident, Trespassing, Vandalism, Disorderly Conduct, Other).
- Status is a dropdown: Open, Under Investigation, Closed.
- Location uses an interactive Leaflet map (OpenStreetMap). Type in the search box for autocomplete — selecting a result fills in all address fields and pins the map. Clicking or dragging the pin reverse-geocodes the position back into the address fields.

### Officers
Fields: badge number, first name, last name, rank, assignments.

- Rank is a dropdown: Officer, Senior Officer, Detective, Corporal, Sergeant, Lieutenant, Captain, Commander, Deputy Chief, Chief.
- Badge number must be unique.

### Arrests
Fields: linked incident, linked person, charges, arrested at, mugshot (image upload).

- Incident and person are selected from dropdowns linked to existing records.
- Mugshot is stored via Active Storage (local disk in development).

### Persons
Fields: first name, last name, date of birth, street address, city, state, ZIP code, notes/history.

- Linked to arrests and vehicles.
- Arrest count shown on index and detail pages.

### Vehicles
Fields: plate number, make, model, year, color, owner (linked person).

- Owner is an optional dropdown linked to a Person record.

### Evidence
Fields: evidence number, description, status, storage location, collected at, collected by, chain of custody.

- Status is a dropdown: Collected, In Lab, In Storage, Released, Destroyed.
- Evidence number must be unique.
- Linked to an incident via dropdown.

---

## Design

- Stripe-inspired UI using the Inter font (Google Fonts).
- Color palette: `#635BFF` primary purple, `#0A2540` dark navy, `#F6F9FC` background.
- Sticky dark nav bar with links to all six modules.
- Index pages use clean data tables with colored status badges.
- Show pages use a structured detail card grid.
- Forms have purple focus rings, a custom select arrow, and a styled submit button.
- Flash messages styled as green (notice) or red (alert) banners.

### Status badge colors

| Value | Color |
|---|---|
| Open | Green |
| Under Investigation | Yellow |
| Closed | Gray |
| Evidence: Collected | Blue |
| Evidence: In Lab | Purple |
| Evidence: In Storage | Gray |
| Evidence: Released | Green |
| Evidence: Destroyed | Red |
| Officer: Chief / Deputy Chief | Purple |
| Officer: Captain / Commander / Detective | Blue |
| Officer: Sergeant / Lieutenant | Yellow |

---

## Key Files Changed from `rails new`

| File | Change |
|---|---|
| `config/puma.rb` | Removed `plugin :tmp_restart` (Windows incompatible) |
| `config/routes.rb` | Added all resource routes + `root "incidents#index"` |
| `app/assets/stylesheets/application.css` | Full Stripe-inspired stylesheet (Inter font, CSS variables, tables, cards, forms, badges) |
| `app/views/layouts/application.html.erb` | Added Inter font, Leaflet CSS/JS CDN, dark nav bar, flash message rendering |
| `app/javascript/controllers/map_controller.js` | Stimulus controller for Leaflet map — autocomplete search, click-to-pin, reverse geocode, drag marker |
| `config/importmap.rb` | Unchanged (Leaflet loaded via CDN script tag) |
| `app/models/incident.rb` | Validations, `has_many :arrests`, `has_many :evidences` |
| `app/models/officer.rb` | Validations, `RANKS` constant |
| `app/models/person.rb` | Validations, `has_many :arrests`, `has_many :vehicles`, `full_name` helper |
| `app/models/vehicle.rb` | Validations, `belongs_to :person` |
| `app/models/arrest.rb` | `belongs_to :incident`, `belongs_to :person`, `has_one_attached :mugshot` |
| `app/models/evidence.rb` | Validations, `belongs_to :incident`, `STATUSES` constant |

## Migrations

| Migration | Description |
|---|---|
| `CreateIncidents` | Initial incidents table |
| `AddLatLngToIncidents` | Added `latitude`, `longitude` float columns |
| `ReplaceLocationWithAddressFieldsInIncidents` | Removed `location` string, added `street_address`, `city`, `state`, `zip_code` |
| `CreateOfficers` | Officers table |
| `CreatePeople` | People table |
| `CreateVehicles` | Vehicles table with `person_id` foreign key |
| `CreateArrests` | Arrests table with `incident_id` and `person_id` foreign keys |
| `CreateEvidences` | Evidences table with `incident_id` foreign key |
| `CreateActiveStorageTables` | Active Storage for mugshot uploads |

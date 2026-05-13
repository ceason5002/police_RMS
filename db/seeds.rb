puts "Clearing existing data..."
UnitStatusLog.destroy_all
CallNote.destroy_all
CallUnit.destroy_all
Bolo.destroy_all
CadCall.destroy_all
CadUnit.destroy_all
AuditLog.destroy_all
OfficerUnit.destroy_all
Evidence.destroy_all
Arrest.destroy_all
Vehicle.destroy_all
Incident.destroy_all
CrimeCase.destroy_all
Person.destroy_all
Officer.destroy_all
Unit.destroy_all
User.destroy_all

# ── Helpers ───────────────────────────────────────────────────────────────────

FIRST_NAMES = %w[James Michael Robert David William Richard Joseph Thomas Charles Christopher
                 Daniel Matthew Anthony Mark Donald Steven Paul Andrew Kenneth Joshua
                 Mary Patricia Jennifer Linda Barbara Susan Jessica Sarah Karen Lisa
                 Nancy Betty Margaret Sandra Ashley Dorothy Kimberly Emily Donna Michelle
                 Carol Amanda Melissa Deborah Stephanie Rebecca Sharon Laura Cynthia].freeze

LAST_NAMES  = %w[Smith Johnson Williams Brown Jones Garcia Miller Davis Wilson Moore
                 Taylor Anderson Thomas Jackson White Harris Martin Thompson Garcia Martinez
                 Robinson Clark Rodriguez Lewis Lee Walker Hall Allen Young Hernandez
                 King Wright Lopez Hill Scott Green Adams Baker Gonzalez Nelson Carter
                 Mitchell Perez Roberts Turner Phillips Campbell Parker Evans Edwards Collins].freeze

STREETS     = ["Main St", "Oak Ave", "Maple Dr", "Cedar Ln", "Elm St", "Pine Rd",
               "Washington Blvd", "Park Ave", "Lake St", "Hill Rd", "River Rd",
               "Forest Dr", "Sunset Blvd", "Meadow Ln", "Church St", "School Rd",
               "1st Ave", "2nd St", "3rd Ave", "Center St", "Broadway", "Highland Ave"].freeze

CITIES = [
  ["Springfield",   "IL", "62701"], ["Riverside",    "CA", "92501"],
  ["Franklin",      "TN", "37064"], ["Greenville",   "SC", "29601"],
  ["Bristol",       "VA", "24201"], ["Clinton",      "IA", "52732"],
  ["Madison",       "WI", "53701"], ["Salem",        "OR", "97301"],
  ["Auburn",        "AL", "36830"], ["Bloomington",  "IN", "47401"],
  ["Columbia",      "MO", "65201"], ["Lexington",    "KY", "40501"],
  ["Baton Rouge",   "LA", "70801"], ["Concord",      "NH", "03301"],
  ["Trenton",       "NJ", "08601"], ["Savannah",     "GA", "31401"],
  ["Raleigh",       "NC", "27601"], ["Richmond",     "VA", "23218"],
  ["Des Moines",    "IA", "50301"], ["Lansing",      "MI", "48901"]
].freeze

INCIDENT_TYPES = ["Assault", "Burglary", "Disorderly Conduct", "Domestic Violence",
                  "Drug Offense", "Fraud", "Homicide", "Missing Person",
                  "Motor Vehicle Theft", "Robbery", "Theft", "Traffic Accident",
                  "Trespassing", "Vandalism", "Other"].freeze

INCIDENT_STATUSES = ["Open", "Under Investigation", "Closed"].freeze
EVIDENCE_STATUSES = ["Collected", "In Lab", "In Storage", "Released", "Destroyed"].freeze
OFFICER_RANKS     = Officer::RANKS

VEHICLE_MAKES = {
  "Ford"       => ["F-150", "Mustang", "Explorer", "Escape", "Focus"],
  "Chevrolet"  => ["Silverado", "Malibu", "Equinox", "Tahoe", "Camaro"],
  "Toyota"     => ["Camry", "Corolla", "RAV4", "Tacoma", "Highlander"],
  "Honda"      => ["Civic", "Accord", "CR-V", "Pilot", "Odyssey"],
  "Dodge"      => ["Charger", "Challenger", "Durango", "Ram 1500", "Journey"],
  "Nissan"     => ["Altima", "Sentra", "Rogue", "Pathfinder", "Maxima"],
  "BMW"        => ["3 Series", "5 Series", "X3", "X5", "M3"],
  "Hyundai"    => ["Elantra", "Sonata", "Tucson", "Santa Fe", "Accent"],
  "Jeep"       => ["Wrangler", "Cherokee", "Grand Cherokee", "Compass", "Renegade"],
  "Volkswagen" => ["Jetta", "Passat", "Tiguan", "Golf", "Atlas"]
}.freeze

COLORS = %w[Black White Silver Gray Red Blue Navy Green Maroon Gold Beige Orange Yellow].freeze

NARRATIVES = [
  "Officers responded to a report from a witness at the scene. Upon arrival, officers observed signs consistent with the reported incident. Statements were collected from multiple individuals present. Evidence was photographed and catalogued at the scene.",
  "Dispatch received a 911 call reporting suspicious activity in the area. Responding officers made contact with individuals matching the description provided by the caller. Investigation is ongoing pending further review of available surveillance footage.",
  "Victim reported the incident after discovering it upon returning to the premises. Officers canvassed the surrounding area and spoke with several neighbors. A detailed report was filed and forwarded to the detective division for follow-up.",
  "Officers on routine patrol observed activity consistent with the reported incident type. Immediate action was taken to ensure public safety. All parties involved were identified and statements were recorded.",
  "Report was filed by the victim the following morning. Officers inspected the scene and documented all physical evidence. Case has been forwarded for further investigation and review.",
  "Multiple witnesses contacted dispatch to report the incident. First responders arrived within minutes and secured the scene. Investigators have been assigned and are actively working the case.",
  "Incident was discovered during a routine inspection by property management. Officers documented the scene and collected physical evidence. A suspect description was circulated to patrol units in the area.",
  "Victim was uncooperative initially but later provided a detailed account of events. Officers documented visible injuries and collected relevant evidence. A suspect has been identified and is being sought for questioning."
].freeze

CHARGES_LIST = [
  "Assault in the 2nd Degree",
  "Possession of Controlled Substance",
  "Burglary in the 1st Degree",
  "Robbery with a Deadly Weapon",
  "Disorderly Conduct",
  "Driving Under the Influence (DUI)",
  "Trespassing",
  "Vandalism / Criminal Mischief",
  "Domestic Violence - Battery",
  "Grand Theft Auto",
  "Fraud / Identity Theft",
  "Possession of Stolen Property",
  "Resisting Arrest",
  "Aggravated Assault",
  "Breaking and Entering"
].freeze

EVIDENCE_DESCRIPTIONS = [
  "Black duffel bag containing cash", "Surveillance footage — USB drive",
  "Fingerprint lift from door frame", "Shell casings — 9mm, qty 3",
  "Broken window glass samples", "Bloodstain swab from scene",
  "White powder substance (field-tested positive)", "Stolen credit cards (qty 4)",
  "Knife with apparent blood staining", "Cell phone — locked, black iPhone",
  "Security camera SD card", "Counterfeit currency — $1,200 face value",
  "Clothing items matching witness description", "Vehicle key fob",
  "Crowbar with tool marks", "Laptop computer — serial number documented",
  "Spray paint cans — 3 colors", "Drug paraphernalia — pipe and rolling papers",
  "Victim's wallet — contents intact", "Handwritten note found at scene",
  "Gloves — latex, pair", "Ski mask — black",
  "Zip ties — qty 6", "Bolt cutters with fresh cut marks",
  "Watch — men's, engraved", "Bag of jewelry — provenance unknown"
].freeze

STORAGE_LOCATIONS = [
  "Evidence Room — Locker 1A", "Evidence Room — Locker 2B", "Evidence Room — Locker 3C",
  "Refrigerated Unit — Bay 1", "Refrigerated Unit — Bay 2",
  "Secure Vault — Shelf 4", "Secure Vault — Shelf 7",
  "Digital Evidence Lab — Drive 12", "Property Room — Bin 22",
  "Property Room — Bin 35", "Narcotics Locker — Cabinet 3"
].freeze

def rand_name
  "#{FIRST_NAMES.sample} #{LAST_NAMES.sample}"
end

def rand_city
  CITIES.sample
end

def rand_address
  "#{rand(100..9999)} #{STREETS.sample}"
end

def rand_date_between(from, to)
  Time.at(rand(from.to_i..to.to_i))
end

two_years_ago = 2.years.ago
now           = Time.now

# ── 1. Officers (100) ────────────────────────────────────────────────────────
puts "Seeding officers..."
100.times do |i|
  first = FIRST_NAMES.sample
  last  = LAST_NAMES.sample
  Officer.create!(
    badge_number: "B%04d" % (1000 + i),
    first_name:   first,
    last_name:    last,
    rank:         OFFICER_RANKS.sample,
    assignments:  ["Patrol District #{rand(1..8)}", "K-9 Unit", "Traffic Division",
                   "Detective Bureau", "Gang Task Force", "Narcotics Unit",
                   "Community Policing", "SWAT", "Juvenile Division"].sample
  )
end

# ── 2. Persons (100) ─────────────────────────────────────────────────────────
puts "Seeding persons..."
100.times do
  city, state, zip = rand_city
  Person.create!(
    first_name:     FIRST_NAMES.sample,
    last_name:      LAST_NAMES.sample,
    date_of_birth:  rand_date_between(50.years.ago, 18.years.ago).to_date,
    street_address: rand_address,
    city:           city,
    state:          state,
    zip_code:       zip,
    notes:          ["No prior record.", "Prior misdemeanor — 2021.", "Known associate of organized activity.",
                     "Prior felony conviction — 2019.", "Active warrant — see file.", ""].sample
  )
end

# ── 3. Incidents (100) ───────────────────────────────────────────────────────
puts "Seeding incidents..."
100.times do |i|
  city, state, zip = rand_city
  occurred = rand_date_between(two_years_ago, now)
  Incident.create!(
    report_number:  "RPT-%04d" % (2024001 + i),
    incident_type:  INCIDENT_TYPES.sample,
    status:         INCIDENT_STATUSES.sample,
    street_address: rand_address,
    city:           city,
    state:          state,
    zip_code:       zip,
    latitude:       (rand * (49.0 - 25.0) + 25.0).round(6),
    longitude:      (rand * (-67.0 - (-124.0)) + (-124.0)).round(6),
    occurred_at:    occurred,
    reported_at:    occurred + rand(1..120).minutes,
    narrative:      NARRATIVES.sample
  )
end

# ── 4. Vehicles (100) ────────────────────────────────────────────────────────
puts "Seeding vehicles..."
people    = Person.all.to_a
incidents = Incident.all.to_a

state_abbrs = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD
                 MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC
                 SD TN TX UT VT VA WA WV WI WY]

100.times do
  make  = VEHICLE_MAKES.keys.sample
  model = VEHICLE_MAKES[make].sample
  plate_state = state_abbrs.sample
  Vehicle.create!(
    plate_number: "#{plate_state}-#{('A'..'Z').to_a.sample(3).join}#{rand(100..999)}",
    make:         make,
    model:        model,
    year:         rand(2005..2024),
    color:        COLORS.sample,
    person:       people.sample
  )
end

# ── 5. Arrests (100) ─────────────────────────────────────────────────────────
puts "Seeding arrests..."
100.times do
  incident = incidents.sample
  arrest_time = incident.occurred_at + rand(30..480).minutes
  Arrest.create!(
    incident:    incident,
    person:      people.sample,
    charges:     CHARGES_LIST.sample(rand(1..3)).join("\n"),
    arrested_at: arrest_time
  )
end

# ── 6. Evidence (100) ────────────────────────────────────────────────────────
puts "Seeding evidence..."
100.times do |i|
  incident     = incidents.sample
  collected    = incident.occurred_at + rand(10..90).minutes
  Evidence.create!(
    incident:       incident,
    evidence_number: "EVD-%04d" % (1000 + i),
    description:    EVIDENCE_DESCRIPTIONS.sample,
    status:         EVIDENCE_STATUSES.sample,
    location_stored: STORAGE_LOCATIONS.sample,
    collected_at:   collected,
    collected_by:   "#{Officer.order("RANDOM()").first&.rank} #{LAST_NAMES.sample}",
    chain_of_custody: "#{collected.strftime('%m/%d/%Y %H:%M')} — Collected at scene by responding officer.\n#{(collected + 2.hours).strftime('%m/%d/%Y %H:%M')} — Transferred to evidence room."
  )
end

# ── 7. Units ─────────────────────────────────────────────────────────────────
puts "Seeding units..."
unit_data = [
  ["Patrol Division",      "Patrol"],
  ["Homicide Unit",        "Homicide"],
  ["Narcotics Unit",       "Narcotics"],
  ["Gang Task Force",      "Gang Task Force"],
  ["Traffic Division",     "Traffic"],
  ["K-9 Unit",             "K-9"],
  ["SWAT Team",            "SWAT"],
  ["Detective Bureau",     "Detective Bureau"],
  ["Juvenile Division",    "Juvenile"],
  ["Community Policing",   "Community Policing"]
]
units = unit_data.map do |name, type|
  Unit.create!(name: name, unit_type: type, description: "#{name} — responsible for #{type.downcase} operations.")
end

officers = Officer.all.to_a
officers.each { |o| o.units << units.sample(rand(1..2)) }

# ── 8. Crime Cases (20) ───────────────────────────────────────────────────────
puts "Seeding crime cases..."
20.times do |i|
  lead = officers.sample
  cc = CrimeCase.create!(
    case_number:  "CASE-%04d" % (1000 + i),
    title:        ["Operation #{%w[Thunder Shadow Eagle Falcon Viper Ghost Hawk Raven Strike Cobra].sample}",
                   "#{INCIDENT_TYPES.sample} Investigation #{2024 + rand(2)}",
                   "Task Force #{%w[Alpha Bravo Charlie Delta Echo].sample}"].sample,
    status:       CrimeCase::STATUSES.sample,
    description:  "Active investigation assigned to #{lead.full_name}. Multiple incidents linked.",
    lead_officer: lead
  )
  Incident.all.to_a.sample(rand(2..5)).each { |inc| inc.update!(crime_case: cc) }
end

# ── 9. Admin User ─────────────────────────────────────────────────────────────
puts "Seeding admin user..."
User.create!(
  login_id: "M1234",
  password: "Admin1234!",
  password_confirmation: "Admin1234!",
  role:     "admin",
  active:   true
)

# ── 10. CAD Data ─────────────────────────────────────────────────────────────
puts "Seeding CAD data..."

dispatcher = User.create!(
  login_id:              "D1001",
  password:              "password123",
  password_confirmation: "password123",
  role:                  "dispatcher",
  active:                true
)

patrol_officers = Officer.where(rank: ["Officer", "Senior Officer", "Corporal", "Sergeant"]).to_a
det_officers    = Officer.where(rank: "Detective").to_a

unit_101 = CadUnit.create!(unit_number: "Unit-101", unit_type: "Patrol",     status: "Dispatched", assigned_officer: patrol_officers.sample)
unit_102 = CadUnit.create!(unit_number: "Unit-102", unit_type: "Patrol",     status: "On Scene",   assigned_officer: patrol_officers.sample)
unit_103 = CadUnit.create!(unit_number: "Unit-103", unit_type: "Patrol",     status: "On Scene",   assigned_officer: patrol_officers.sample)
unit_k9  = CadUnit.create!(unit_number: "K9-1",     unit_type: "K9",         status: "Available",  assigned_officer: patrol_officers.sample)
unit_det = CadUnit.create!(unit_number: "Det-201",  unit_type: "Detective",  status: "Dispatched", assigned_officer: det_officers.any? ? det_officers.sample : patrol_officers.sample)
unit_sup = CadUnit.create!(unit_number: "Sup-1",    unit_type: "Supervisor", status: "Available",  assigned_officer: patrol_officers.sample)
unit_tfc = CadUnit.create!(unit_number: "Tfc-301",  unit_type: "Traffic",    status: "Off Duty",   assigned_officer: patrol_officers.sample)
unit_swt = CadUnit.create!(unit_number: "SWAT-1",   unit_type: "SWAT",       status: "Off Duty",   assigned_officer: patrol_officers.sample)

cad_units_all = [unit_101, unit_102, unit_103, unit_k9, unit_det, unit_sup, unit_tfc, unit_swt]
shift_start = now - 8.hours
cad_units_all.each do |u|
  UnitStatusLog.create!(cad_unit: u, status: "Available", changed_by: dispatcher, changed_at: shift_start)
  UnitStatusLog.create!(cad_unit: u, status: u.status,    changed_by: dispatcher, changed_at: shift_start + rand(10..60).minutes) unless u.status == "Available"
end

# Active calls
shots_call = CadCall.create!(
  call_type: "Shots Fired", priority: 1, status: "On Scene",
  location: "400 Oak Ave, Springfield, IL",
  description: "Multiple reports of gunshots fired near apartment complex. Possible injured party.",
  caller_name: "Anon Caller", received_at: now - 35.minutes,
  dispatched_at: now - 32.minutes, on_scene_at: now - 28.minutes,
  created_by: dispatcher
)
CallNote.create!(cad_call: shots_call, user: dispatcher, body: "Call received — shots fired reported by multiple neighbors.")
CallNote.create!(cad_call: shots_call, user: dispatcher, body: "Unit-103 on scene. One possible GSW victim. EMS requested.")
CallUnit.create!(cad_call: shots_call, cad_unit: unit_103, assigned_at: shots_call.dispatched_at)

dv_call = CadCall.create!(
  call_type: "Domestic Violence", priority: 1, status: "Dispatched",
  location: "218 Elm St, Madison, WI",
  description: "Neighbor reporting loud argument, sounds of breaking objects. Female screaming.",
  caller_name: "Neighbor", caller_phone: "555-0182", received_at: now - 12.minutes,
  dispatched_at: now - 9.minutes, created_by: dispatcher
)
CallNote.create!(cad_call: dv_call, user: dispatcher, body: "Call received — DV in progress, caller reports female screaming.")
CallUnit.create!(cad_call: dv_call, cad_unit: unit_101, assigned_at: dv_call.dispatched_at)

robbery_call = CadCall.create!(
  call_type: "Robbery", priority: 2, status: "Dispatched",
  location: "930 Main St, Riverside, CA",
  description: "Armed robbery at convenience store. Suspect fled on foot heading west. Dark clothing.",
  caller_name: "Store Clerk", caller_phone: "555-0241", received_at: now - 20.minutes,
  dispatched_at: now - 16.minutes, created_by: dispatcher
)
CallNote.create!(cad_call: robbery_call, user: dispatcher, body: "Store clerk reports suspect displayed handgun and demanded cash.")
CallUnit.create!(cad_call: robbery_call, cad_unit: unit_det, assigned_at: robbery_call.dispatched_at)

CadCall.create!(
  call_type: "Assault", priority: 2, status: "Pending",
  location: "77 Pine Rd, Raleigh, NC",
  description: "Victim reports being assaulted by unknown male outside a bar. Minor injuries.",
  caller_name: "Victim", received_at: now - 5.minutes, created_by: dispatcher
)

traffic_call = CadCall.create!(
  call_type: "Traffic Accident", priority: 3, status: "On Scene",
  location: "Intersection of Broadway & 1st Ave, Franklin, TN",
  description: "Two-vehicle collision with airbag deployment. No reported injuries but traffic blocked.",
  caller_name: "Motorist", caller_phone: "555-0317", received_at: now - 45.minutes,
  dispatched_at: now - 40.minutes, on_scene_at: now - 35.minutes,
  created_by: dispatcher
)
CallNote.create!(cad_call: traffic_call, user: dispatcher, body: "Unit-102 on scene. Two vehicles involved, no injuries. Tow requested.")
CallUnit.create!(cad_call: traffic_call, cad_unit: unit_102, assigned_at: traffic_call.dispatched_at)

CadCall.create!(
  call_type: "Suspicious Activity", priority: 3, status: "Pending",
  location: "1204 Cedar Ln, Salem, OR",
  description: "Caller reports unknown vehicle parked for 3+ hours with occupant watching houses.",
  caller_name: "Resident", received_at: now - 8.minutes, created_by: dispatcher
)

CadCall.create!(
  call_type: "Noise Complaint", priority: 4, status: "Pending",
  location: "56 Park Ave, Lexington, KY",
  description: "Loud music from residence, repeated calls from neighbors.",
  caller_name: "Neighbor", received_at: now - 3.minutes, created_by: dispatcher
)

# Cleared calls (historical)
welfare_call = CadCall.create!(
  call_type: "Welfare Check", priority: 4, status: "Cleared",
  location: "324 Maple Dr, Columbia, MO",
  description: "Family member requesting welfare check on elderly resident who is not answering calls.",
  caller_name: "Family Member", caller_phone: "555-0489",
  received_at: now - 90.minutes, dispatched_at: now - 86.minutes,
  on_scene_at: now - 80.minutes, cleared_at: now - 65.minutes,
  created_by: dispatcher
)
CallNote.create!(cad_call: welfare_call, user: dispatcher, body: "Resident located, in good health. Closed.")

dui_call = CadCall.create!(
  call_type: "DUI", priority: 2, status: "Cleared",
  location: "Highway 74 & Center St, Auburn, AL",
  description: "Motorist observed driving erratically, crossing centerline. Possible impaired driver.",
  caller_name: "Motorist", received_at: now - 3.hours,
  dispatched_at: now - 3.hours + 4.minutes,
  on_scene_at:   now - 3.hours + 12.minutes,
  cleared_at:    now - 2.5.hours,
  created_by: dispatcher
)
CallNote.create!(cad_call: dui_call, user: dispatcher, body: "Driver arrested for DUI. Vehicle towed. Report filed.")

vandalism_call = CadCall.create!(
  call_type: "Vandalism", priority: 5, status: "Cleared",
  location: "800 Highland Ave, Savannah, GA",
  description: "Business owner reports graffiti on rear exterior wall, discovered this morning.",
  caller_name: "Business Owner", received_at: now - 5.hours,
  dispatched_at: now - 5.hours + 6.minutes,
  on_scene_at:   now - 5.hours + 18.minutes,
  cleared_at:    now - 4.hours,
  created_by: dispatcher
)
CallNote.create!(cad_call: vandalism_call, user: dispatcher, body: "Photos taken, report filed. No suspect at scene.")

# BOLOs
bolo_officer = Officer.order("RANDOM()").first

Bolo.create!(
  subject_description: "Male, approx. 6'1\", medium build, black hoodie, gray jeans, face tattoo on left cheek. Last seen running north on Oak Ave.",
  vehicle_description: "2019 Black Ford F-150, partial plate IL-XR7***",
  last_known_location: "400 Oak Ave, Springfield, IL",
  issuing_officer:     bolo_officer,
  created_by:          dispatcher,
  status:              "Active",
  expires_at:          24.hours.from_now
)

Bolo.create!(
  subject_description: "Female, 30s, short red hair, blue scrubs, tote bag. Wanted for questioning in pharmacy theft.",
  last_known_location: "Mercy General Hospital area, Madison, WI",
  issuing_officer:     Officer.order("RANDOM()").first,
  created_by:          dispatcher,
  status:              "Active",
  expires_at:          48.hours.from_now
)

Bolo.create!(
  vehicle_description: "2017 Silver Toyota Camry, plate GA-BFP442. Reported stolen. No violent history on file.",
  last_known_location: "I-16 westbound near Exit 22, Savannah, GA",
  issuing_officer:     Officer.order("RANDOM()").first,
  created_by:          dispatcher,
  status:              "Resolved"
)

puts ""
puts "Done! Seeded:"
puts "  #{Officer.count}         officers"
puts "  #{Person.count}          persons"
puts "  #{Incident.count}        incidents"
puts "  #{Vehicle.count}         vehicles"
puts "  #{Arrest.count}          arrests"
puts "  #{Evidence.count}        evidence items"
puts "  #{Unit.count}            units"
puts "  #{CrimeCase.count}       cases"
puts "  #{CadUnit.count}         CAD units"
puts "  #{CadCall.count}         CAD calls"
puts "  #{Bolo.count}            BOLOs"
puts "  #{User.count}            users"
puts ""
puts "Admin login:      M1234 / Admin1234!"
puts "Dispatcher login: D1001 / password123"
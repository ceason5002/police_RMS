puts "Clearing existing data..."
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
  email:    "admin@policerms.local",
  password: "Admin1234!",
  password_confirmation: "Admin1234!",
  role:     "admin",
  active:   true
)

puts ""
puts "Done! Seeded:"
puts "  #{Officer.count}   officers"
puts "  #{Person.count}    persons"
puts "  #{Incident.count}  incidents"
puts "  #{Vehicle.count}   vehicles"
puts "  #{Arrest.count}    arrests"
puts "  #{Evidence.count}  evidence items"
puts "  #{Unit.count}      units"
puts "  #{CrimeCase.count} cases"
puts "  #{User.count}      users"
puts ""
puts "Admin login: admin@policerms.local / Admin1234!"
# Seed data for development / demo. Idempotent-ish: wipes domain tables then
# rebuilds a realistic dataset so every screen renders with content.
require "securerandom"

puts "Seeding Karting platform…"

[Lap, RaceEntry, BestLap, Race, ChampionshipStanding, TournamentMatch,
 Booking, Registration, Payment, Subscription, GalleryItem, Notification,
 SessionPrice, MembershipPlan, Competition, Event, KartType, OpeningHour,
 Driver, Track, Venue].each(&:delete_all)
User.delete_all

# --- Venue + hours ---
venue = Venue.create!(
  name: "Apex Karting",
  description: "A world-class indoor & outdoor karting circuit featuring electric and combustion fleets, professional live timing and championship competition.",
  address: "Zone Industrielle, Route de l'Aéroport", city: "Casablanca", country: "Morocco",
  phone: "+212 522 000 000", email: "hello@apexkarting.example",
  latitude: 33.5731, longitude: -7.5898,
  socials: { "instagram" => "https://instagram.com", "facebook" => "https://facebook.com", "youtube" => "https://youtube.com" }
)
(0..6).each do |dow|
  closed = dow == 1 # Mondays closed
  venue.opening_hours.create!(day_of_week: dow, closed: closed,
                              opens_at: closed ? nil : "10:00", closes_at: closed ? nil : "23:00")
end

track = Track.create!(name: "Grand Circuit", description: "Technical 14-turn layout with a long back straight.", length_m: 1180, corners: 14, surface: "Asphalt")

# --- Kart types ---
karts = [
  { name: "Rookie 120", category: :kids, top_speed_kmh: 40, power_hp: 5.5, engine: "Honda GX160", weight_kg: 70, min_age: 7, min_height_cm: 120, description: "Safe, fun karts for young first-timers." },
  { name: "Sport 270", category: :adult, top_speed_kmh: 70, power_hp: 9, engine: "Honda GX270", weight_kg: 95, min_age: 14, min_height_cm: 150, description: "The all-rounder for adult arrive-and-drive sessions." },
  { name: "GT Twin", category: :twin, top_speed_kmh: 80, power_hp: 13, engine: "Twin 390cc", weight_kg: 110, min_age: 16, min_height_cm: 160, description: "Two-seater for instructor laps and experiences." },
  { name: "Volt EV", category: :electric, top_speed_kmh: 75, power_hp: 20, engine: "Electric 15kW", weight_kg: 130, min_age: 16, min_height_cm: 155, description: "Instant-torque electric kart, silent and savage." },
  { name: "Pro RX", category: :pro, top_speed_kmh: 95, power_hp: 25, engine: "Rotax 125 DD2", weight_kg: 90, min_age: 18, min_height_cm: 165, description: "Race-spec shifter kart for licensed drivers." }
]
kart_records = karts.each_with_index.map do |attrs, i|
  KartType.create!(attrs.merge(position: i, active: true))
end

# --- Session pricing ---
[
  { name: "Single Sprint", category: :solo, kart_type: kart_records[1], duration_minutes: 15, laps: 20, price_cents: 25_00 },
  { name: "Kids Session", category: :kids, kart_type: kart_records[0], duration_minutes: 10, laps: 14, price_cents: 18_00 },
  { name: "Group Race", category: :group_session, kart_type: kart_records[1], duration_minutes: 20, laps: 25, price_cents: 35_00 },
  { name: "Electric Experience", category: :solo, kart_type: kart_records[3], duration_minutes: 15, laps: 22, price_cents: 32_00 },
  { name: "Endurance 60", category: :endurance, kart_type: kart_records[4], duration_minutes: 60, laps: 80, price_cents: 90_00 },
  { name: "VIP Pro", category: :vip, kart_type: kart_records[4], duration_minutes: 30, laps: 40, price_cents: 75_00 }
].each_with_index { |a, i| SessionPrice.create!(a.merge(position: i, active: true, currency: "EUR")) }

# --- Membership plans ---
[
  { name: "Bronze", period: :monthly, price_cents: 49_00, popular: false, benefits: ["2 sessions / month", "10% off extra sessions", "Online booking"] },
  { name: "Silver", period: :monthly, price_cents: 89_00, popular: true, benefits: ["5 sessions / month", "20% off extra sessions", "Priority booking", "Free helmet rental"] },
  { name: "Gold", period: :yearly, price_cents: 899_00, popular: false, benefits: ["Unlimited sessions", "30% off competitions", "Personal transponder", "Exclusive events", "Pro coaching"] }
].each_with_index { |a, i| MembershipPlan.create!(a.merge(position: i, active: true, currency: "EUR")) }

# --- Users + drivers ---
admin = User.create!(email: "admin@apexkarting.example", password: "password", role: :admin, first_name: "Admin", last_name: "Apex", locale: "fr")
customer = User.create!(email: "driver@apexkarting.example", password: "password", role: :customer, first_name: "Yassine", last_name: "B.", locale: "fr")

driver_names = %w[Speedy Falcon Nitro Vortex Blaze Comet Rocket Drift Phantom Apex Turbo Razor]
drivers = driver_names.each_with_index.map do |nick, i|
  user = i.zero? ? customer : nil
  Driver.create!(user: user, nickname: nick, country: %w[MA FR ES PT IT].sample,
                 transponder_id: "TX-#{1000 + i}", total_races: rand(5..40),
                 best_lap_ms: rand(41_000..48_000), points: rand(0..250))
end

# --- Gallery ---
6.times { |i| GalleryItem.create!(title: "Track shot #{i + 1}", category: GalleryItem.categories.keys.sample, media_kind: :photo, position: i, featured: i < 2) }

# --- Events ---
[
  { name: "Friday Night Lights", kind: :event, starts_at: 5.days.from_now.change(hour: 20), location: "Main Circuit", featured: true, description: "After-dark racing with LED-lit track and DJ." },
  { name: "Corporate Grand Prix", kind: :corporate, starts_at: 12.days.from_now.change(hour: 14), location: "Full Facility", description: "Team-building endurance event for companies." }
].each { |a| Event.create!(a) }

# --- Competitions ---
champ = Competition.create!(name: "Apex Winter Championship", format: :championship, status: :registration_open,
                            starts_at: 7.days.from_now, ends_at: 60.days.from_now,
                            registration_opens_at: 1.day.ago, registration_closes_at: 6.days.from_now,
                            capacity: 24, entry_fee_cents: 40_00, currency: "EUR", track: track,
                            description: "Six-round winter championship across sprint and endurance formats.")
sprint = Competition.create!(name: "Saturday Sprint Cup", format: :sprint, status: :announced,
                             starts_at: 3.days.from_now, capacity: 16, entry_fee_cents: 25_00, currency: "EUR", track: track,
                             description: "Fast knockout sprints, winner takes the cup.")

drivers.first(8).each_with_index do |d, i|
  champ.championship_standings.create!(driver: d, points: (8 - i) * 25 + rand(0..10), position: i + 1, wins: rand(0..3), rounds_completed: rand(1..6))
end
4.times do |slot|
  champ.tournament_matches.create!(round: 1, slot: slot, driver_a: drivers[slot * 2], driver_b: drivers[slot * 2 + 1])
end

# --- Races: one live, some finished, some scheduled ---
def populate_laps(race, drivers, karts, laps_per: 12)
  entries = drivers.first(8).each_with_index.map do |driver, i|
    race.race_entries.create!(driver: driver, kart_type: karts.sample, kart_number: i + 1,
                              transponder_id: driver.transponder_id, grid_position: i + 1, status: :on_track)
  end
  ingestor = Timing::Ingestor.new(race)
  laps_per.times do
    entries.each do |entry|
      ingestor.ingest(Timing::LapEvent.new(transponder_id: entry.transponder_id, kart_number: entry.kart_number,
                                            lap_time_ms: rand(41_000..49_000), recorded_at: rand(1..60).minutes.ago))
    end
  end
  entries
end

live = Race.create!(name: "Open Practice — Live", track: track, status: :live, race_type: :practice,
                    scheduled_at: 10.minutes.ago, started_at: 10.minutes.ago, total_laps: 30)
populate_laps(live, drivers, kart_records, laps_per: 6)

finished = Race.create!(name: "Heat 1 — Winter Champ", competition: champ, track: track, status: :finished,
                        race_type: :heat, scheduled_at: 2.days.ago, started_at: 2.days.ago, ended_at: 2.days.ago + 20.minutes, total_laps: 15)
fin_entries = populate_laps(finished, drivers, kart_records, laps_per: 15)
fin_entries.sort_by { |e| e.total_time_ms || Float::INFINITY }.each_with_index do |e, i|
  e.update!(finish_position: i + 1, status: :finished)
end

2.times do |i|
  Race.create!(name: "Sprint Qualifier #{i + 1}", competition: sprint, track: track, status: :scheduled,
               race_type: :qualifying, scheduled_at: (i + 1).days.from_now.change(hour: 18), total_laps: 12)
end

# --- A sample booking + registration for the demo customer ---
sp = SessionPrice.first
Booking.create!(user: customer, session_price: sp, kart_type: sp.kart_type, starts_at: 2.days.from_now.change(hour: 19), party_size: 2, status: :confirmed)
champ.registrations.create!(user: customer, driver: customer.driver, status: :confirmed)

# --- Attach real karting photos via ActiveStorage ---
def attach_image(attachable, relative)
  path = Rails.root.join("app/assets/images", relative)
  return unless File.exist?(path)

  attachable.attach(io: File.open(path), filename: File.basename(relative), content_type: "image/jpeg")
end

kart_files = %w[karts/rookie.jpg karts/sport.jpg karts/twin.jpg karts/electric.jpg karts/pro.jpg]
kart_records.each_with_index { |k, i| attach_image(k.photo, kart_files[i]) }
GalleryItem.ordered.each_with_index { |g, i| attach_image(g.image, "gallery/g#{(i % 6) + 1}.jpg") }
attach_image(track.layout_image, "track.jpg")
attach_image(champ.banner, "banners/champ.jpg")
attach_image(sprint.banner, "banners/sprint.jpg")
Event.find_by(name: "Friday Night Lights")&.then { |e| attach_image(e.banner, "banners/friday.jpg") }
Event.find_by(name: "Corporate Grand Prix")&.then { |e| attach_image(e.banner, "banners/corporate.jpg") }
attach_image(venue.hero_image, "hero.jpg")
%w[gallery/g1.jpg gallery/g4.jpg track.jpg].each { |f| attach_image(venue.photos, f) }

puts "Done. Admin: admin@apexkarting.example / password — Customer: driver@apexkarting.example / password"

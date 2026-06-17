# Apex Karting — Premium Karting Platform

Mobile-first, PWA-enabled karting platform: marketing site, online booking + payments,
live race timing over WebSockets, competitions/championships, customer + admin dashboards.
Multi-language (Français / English / العربية with RTL).

**Stack:** Rails 7.2 · Hotwire (Turbo + Stimulus) · PostgreSQL · Redis · Sidekiq ·
Tailwind v4 · Devise · Pundit · ActiveStorage · money-rails · friendly_id.

## Getting started

```bash
bundle install
bin/rails db:prepare db:seed   # create + migrate + seed demo data
redis-server                   # if not already running
bin/dev                        # web + tailwind watch + sidekiq worker
```

App on http://localhost:3000.

### Demo accounts
- Admin: `admin@apexkarting.example` / `password`
- Customer: `driver@apexkarting.example` / `password`

## Architecture map

| Area | Code |
|------|------|
| Public site | `HomeController`, `KartsController`, `PricingController`, `MembershipsController`, `CompetitionsController`, `EventsController`, `GalleryController`, `VenueController`, `ContactController` |
| Live racing | `RacesController`, `LeaderboardsController`, `RecordsController`, `DriversController` + Turbo Streams |
| Customer dashboard | `Account::*` (layout `layouts/account`) |
| Admin / race mgmt | `Admin::*` — generic CRUD via `Admin::ResourceController`, custom `Admin::RacesController` |
| Domain | `app/models/*` (25 models) |
| i18n | `config/locales/{fr,en,ar}.yml`, locale in URL scope `(/:locale)` |
| PWA | `PwaController`, `app/views/pwa/*`, `app/javascript/application.js` |

## Real-time live timing

Lap data flows through a hardware-agnostic pipeline so any timing system plugs in:

```
Timing::BaseAdapter  ->  Timing::LapEvent  ->  Timing::Ingestor  ->  Turbo Stream broadcast
```

- `Timing::SimulatedAdapter` generates realistic laps for development/demo
  (`RaceSimulationJob` drives it while a race is `live`).
- **To connect real hardware** (SMS-Timing, MyLaps/AMB X2, …): subclass
  `Timing::BaseAdapter`, implement `#poll` or `#each_event` to emit `Timing::LapEvent`s,
  feed them to `Timing::Ingestor#ingest`, and set `ENV["TIMING_ADAPTER"]`.
  Leaderboard, records, driver stats and broadcasts are shared — nothing else changes.

Race lifecycle: `RaceManager.start!` / `RaceManager.finish!` (admin dashboard buttons).
Clients subscribe via `turbo_stream_from race.turbo_stream_channel`.

## Payments

Provider-agnostic interface (`PaymentService` + `PaymentAdapters::*`). The default
`NullAdapter` marks payments paid immediately so the full booking / registration /
subscription flow works today. **To integrate a provider** (Stripe, PayPal, a MENA
gateway, …): add `PaymentAdapters::<Name>Adapter < BaseAdapter`, implement
`#start_checkout` and `#handle_webhook`, and set `ENV["PAYMENT_PROVIDER"]`.
Webhook endpoint: `POST /payments/webhook`.

## Notes
- Lock down `/sidekiq` before production (currently mounted open).
- `DEFAULT_CURRENCY` env var sets the money currency (default `EUR`).
- Images use ActiveStorage; attach kart photos, gallery media and banners via the admin.

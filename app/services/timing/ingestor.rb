module Timing
  # Turns a normalized LapEvent into persisted data and pushes live updates.
  # Shared by every adapter (simulated or real hardware) so the realtime
  # behaviour is identical no matter where the data comes from.
  class Ingestor
    def initialize(race)
      @race = race
    end

    def ingest(event)
      entry = find_entry(event)
      return if entry.nil?

      lap = create_lap(entry, event)
      entry.update!(status: :on_track) if entry.registered?
      entry.recompute!
      maybe_record_best_lap(entry, lap)
      broadcast_leaderboard
      lap
    end

    private

    attr_reader :race

    def find_entry(event)
      scope = race.race_entries
      if event.transponder_id.present?
        scope.find_by(transponder_id: event.transponder_id)
      end || scope.find_by(kart_number: event.kart_number)
    end

    def create_lap(entry, event)
      number = event.lap_number || (entry.laps.maximum(:lap_number).to_i + 1)
      entry.laps.create!(
        lap_number: number,
        lap_time_ms: event.lap_time_ms,
        sector_times: event.sector_times,
        recorded_at: event.recorded_at
      )
    end

    def maybe_record_best_lap(entry, lap)
      driver = entry.driver
      return if driver.nil?

      if driver.best_lap_ms.nil? || lap.lap_time_ms < driver.best_lap_ms
        driver.update_columns(best_lap_ms: lap.lap_time_ms)
      end

      BestLap.create!(
        driver: driver,
        track: race.track,
        kart_type: entry.kart_type,
        race: race,
        lap_time_ms: lap.lap_time_ms,
        recorded_at: lap.recorded_at
      )
    end

    def broadcast_leaderboard
      Turbo::StreamsChannel.broadcast_replace_to(
        race.turbo_stream_channel,
        target: "race_#{race.id}_leaderboard",
        partial: "races/leaderboard",
        locals: { race: race }
      )
    end
  end
end

module Timing
  # Generates realistic lap events for a race so the live UI, leaderboard and
  # WebSocket pipeline can be developed and demoed before real timing hardware
  # is connected. Each driver has a base pace plus random variation.
  class SimulatedAdapter < BaseAdapter
    def poll
      race.race_entries.where(status: [ :on_track, :registered ]).map do |entry|
        Timing::LapEvent.new(
          transponder_id: entry.transponder_id,
          kart_number: entry.kart_number,
          lap_time_ms: simulate_lap_ms(entry),
          recorded_at: Time.current
        )
      end
    end

    private

    # Base pace 38s–48s per kart, +/- up to 1.5s jitter, occasional slow lap.
    def simulate_lap_ms(entry)
      base = pace_for(entry)
      jitter = rand(-1500..1500)
      penalty = rand < 0.08 ? rand(2000..6000) : 0
      [ base + jitter + penalty, 25_000 ].max
    end

    def pace_for(entry)
      @pace ||= {}
      @pace[entry.id] ||= 38_000 + (entry.kart_number.to_i * 137 % 10_000)
    end
  end
end

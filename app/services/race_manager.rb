# Orchestrates race lifecycle + live broadcasts. Starting a race kicks off the
# timing feed (simulated by default, real adapter in production).
class RaceManager
  class << self
    def start!(race)
      race.update!(status: :live, started_at: Time.current)
      race.race_entries.update_all(status: RaceEntry.statuses[:on_track])
      broadcast_status(race)
      notify(race, kind: :race_start, title: "Race started", body: race.name)
      RaceSimulationJob.perform_async(race.id) if simulated?
      race
    end

    def finish!(race)
      race.update!(status: :finished, ended_at: Time.current)
      rank_finishers(race)
      broadcast_status(race)
      notify(race, kind: :race_result, title: "Race finished", body: race.name)
      race
    end

    private

    def simulated?
      ENV.fetch("TIMING_ADAPTER", "simulated") == "simulated"
    end

    def rank_finishers(race)
      race.leaderboard.each_with_index do |entry, idx|
        entry.update_columns(finish_position: idx + 1, status: RaceEntry.statuses[:finished])
      end
    end

    def broadcast_status(race)
      Turbo::StreamsChannel.broadcast_replace_to(
        race.turbo_stream_channel,
        target: "race_#{race.id}_status",
        partial: "races/status",
        locals: { race: race }
      )
    end

    def notify(race, kind:, title:, body:)
      Notification.create!(kind: kind, title: title, body: body, broadcast: true, data: { race_id: race.id }).deliver!
    end
  end
end

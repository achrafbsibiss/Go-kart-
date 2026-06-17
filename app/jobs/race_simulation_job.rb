# Drives the simulated timing feed for a live race. Emits one round of laps
# (one per kart on track) then re-enqueues itself a few seconds later until the
# race reaches its lap target or is no longer live. Replace by connecting a
# real Timing adapter for production hardware.
class RaceSimulationJob
  include Sidekiq::Job
  sidekiq_options queue: :timing, retry: 1

  INTERVAL = 4 # seconds between simulated lap rounds

  def perform(race_id)
    race = Race.find_by(id: race_id)
    return unless race&.live?

    adapter = Timing::SimulatedAdapter.new(race: race)
    ingestor = Timing::Ingestor.new(race)
    adapter.poll.each { |event| ingestor.ingest(event) }

    leader = race.leaderboard.first
    done = race.total_laps.present? && leader && leader.laps_completed.to_i >= race.total_laps
    if done
      RaceManager.finish!(race)
    else
      self.class.perform_in(INTERVAL, race_id)
    end
  end
end

class HomeController < ApplicationController
  def index
    @live_races = Race.live_now.includes(:track).limit(3)
    @upcoming_events = Event.upcoming.limit(4)
    @upcoming_competitions = Competition.upcoming.limit(3)
    @featured_karts = KartType.active.ordered.limit(4)
    @track = Track.first
    @records = BestLap.records
  end

  # Offline fallback rendered by the service worker.
  def offline
    render layout: "application"
  end
end

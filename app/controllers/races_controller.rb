class RacesController < ApplicationController
  def index
    @live = Race.live_now.includes(:track, :competition)
    @scheduled = Race.scheduled.where("scheduled_at >= ?", Time.current.beginning_of_day).order(:scheduled_at).limit(8)
    @finished = Race.finished.order(ended_at: :desc).limit(6)
  end

  def show
    @race = Race.includes(race_entries: %i[driver kart_type]).find(params[:id])
  end
end

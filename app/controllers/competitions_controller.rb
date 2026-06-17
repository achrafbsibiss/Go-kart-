class CompetitionsController < ApplicationController
  def index
    @upcoming = Competition.where.not(status: %i[draft completed canceled]).order(:starts_at)
    @past = Competition.where(status: :completed).order(starts_at: :desc).limit(6)
  end

  def show
    @competition = Competition.friendly.find(params[:id])
    @standings = @competition.championship_standings.ranked.includes(:driver)
    @matches = @competition.tournament_matches.includes(:driver_a, :driver_b, :winner).order(:round, :slot)
    @races = @competition.races.recent
  end
end

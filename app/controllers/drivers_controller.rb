class DriversController < ApplicationController
  def index
    @drivers = Driver.ranked.includes(:user)
  end

  def show
    @driver = Driver.friendly.find(params[:id])
    @entries = @driver.race_entries.includes(race: :track).order(created_at: :desc).limit(20)
    @best_laps = @driver.best_laps.fastest.limit(5)
  end
end

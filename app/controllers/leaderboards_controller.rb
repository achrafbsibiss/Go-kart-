class LeaderboardsController < ApplicationController
  def index
    @drivers = Driver.ranked.limit(50)
    @records = BestLap.records
  end
end

class RecordsController < ApplicationController
  def index
    @records = BestLap.records
    @top_day = BestLap.today.fastest.includes(:driver, :kart_type).limit(10)
    @top_all = BestLap.fastest.includes(:driver, :kart_type).limit(10)
  end
end

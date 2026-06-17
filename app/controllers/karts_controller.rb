class KartsController < ApplicationController
  def index
    @karts = KartType.active.ordered
  end

  def show
    @kart = KartType.friendly.find(params[:id])
    @sessions = @kart.session_prices.active.ordered
    @related = KartType.active.where.not(id: @kart.id).ordered.limit(3)
  end
end

class PricingController < ApplicationController
  def index
    @sessions = SessionPrice.active.ordered.includes(:kart_type)
  end
end

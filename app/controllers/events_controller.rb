class EventsController < ApplicationController
  def index
    @upcoming = Event.upcoming
    @featured = Event.featured.upcoming.first
  end

  def show
    @event = Event.friendly.find(params[:id])
  end
end

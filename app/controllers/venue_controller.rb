class VenueController < ApplicationController
  def show
    @venue = current_venue
    @opening_hours = @venue.opening_hours.ordered
    @track = Track.first
  end
end

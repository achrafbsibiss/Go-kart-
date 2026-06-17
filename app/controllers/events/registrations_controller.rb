module Events
  class RegistrationsController < ApplicationController
    before_action :authenticate_user!

    def new
      @event = Event.friendly.find(params[:event_id])
      @registration = @event.registrations.new
    end

    def create
      @event = Event.friendly.find(params[:event_id])
      @registration = @event.registrations.new(user: current_user, driver: current_user.driver)

      if @registration.save
        redirect_to account_registrations_path, notice: t("events.title")
      else
        render :new, status: :unprocessable_entity
      end
    end
  end
end

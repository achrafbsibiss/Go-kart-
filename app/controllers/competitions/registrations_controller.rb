module Competitions
  class RegistrationsController < ApplicationController
    before_action :authenticate_user!

    def new
      @competition = Competition.friendly.find(params[:competition_id])
      @registration = @competition.registrations.new
    end

    def create
      @competition = Competition.friendly.find(params[:competition_id])
      @registration = @competition.registrations.new(user: current_user, driver: current_user.driver)

      if @registration.save
        PaymentService.checkout(payable: @registration, user: current_user) if @competition.entry_fee_cents.to_i.positive?
        redirect_to account_registrations_path, notice: t("competitions.register")
      else
        render :new, status: :unprocessable_entity
      end
    end
  end
end

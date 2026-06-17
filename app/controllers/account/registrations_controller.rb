module Account
  class RegistrationsController < BaseController
    def index
      @registrations = current_user.registrations.includes(:registerable).order(created_at: :desc)
    end

    def show
      @registration = current_user.registrations.find(params[:id])
    end
  end
end

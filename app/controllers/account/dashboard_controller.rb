module Account
  class DashboardController < BaseController
    def show
      @bookings = current_user.bookings.upcoming.limit(5)
      @registrations = current_user.registrations.active.includes(:registerable).limit(5)
      @subscription = current_user.subscriptions.current.first
      @driver = current_user.driver
    end
  end
end

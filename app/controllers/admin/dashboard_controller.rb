module Admin
  class DashboardController < BaseController
    def show
      @live_races = Race.live_now.includes(:track)
      @scheduled_races = Race.scheduled.order(:scheduled_at).limit(5)
      @today_bookings = Booking.where(starts_at: Time.current.all_day).order(:starts_at)
      @recent_registrations = Registration.includes(:user, :registerable).order(created_at: :desc).limit(8)
      @counts = {
        drivers: Driver.count,
        bookings: Booking.count,
        competitions: Competition.count,
        revenue_cents: Payment.successful.sum(:amount_cents)
      }
    end
  end
end

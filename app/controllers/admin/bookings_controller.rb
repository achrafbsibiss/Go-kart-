module Admin
  class BookingsController < ResourceController
    private

    def resource_scope
      Booking.includes(:user, :session_price).order(starts_at: :desc)
    end

    def permitted_attributes
      %w[status starts_at party_size notes]
    end
  end
end

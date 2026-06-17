module Account
  class BookingsController < BaseController
    before_action :set_booking, only: %i[show destroy]

    def index
      @bookings = current_user.bookings.order(starts_at: :desc)
    end

    def show; end

    def new
      @booking = current_user.bookings.new(party_size: 1, starts_at: 1.day.from_now.change(hour: 18))
      load_options
    end

    def create
      @booking = current_user.bookings.new(booking_params)
      if @booking.save
        result = PaymentService.checkout(payable: @booking, user: current_user)
        if result.redirect_url
          redirect_to result.redirect_url, allow_other_host: true
        else
          redirect_to account_booking_path(@booking), notice: t("booking.confirmed", ref: @booking.reference)
        end
      else
        load_options
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @booking.update(status: :canceled)
      redirect_to account_bookings_path, notice: t("actions.cancel")
    end

    private

    def set_booking
      @booking = current_user.bookings.find(params[:id])
    end

    def load_options
      @sessions = SessionPrice.active.ordered.includes(:kart_type)
      @karts = KartType.active.ordered
    end

    def booking_params
      params.require(:booking).permit(:session_price_id, :kart_type_id, :starts_at, :party_size, :notes)
    end
  end
end

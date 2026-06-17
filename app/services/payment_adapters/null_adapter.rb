module PaymentAdapters
  # Development / not-yet-integrated adapter. Marks payments paid immediately
  # and confirms the related payable so the whole booking flow is testable
  # before a real gateway is chosen. Swap via ENV["PAYMENT_PROVIDER"].
  class NullAdapter < BaseAdapter
    def provider_name = "manual"

    def start_checkout(payment)
      payment.update!(status: :paid, provider_ref: "SIMULATED-#{SecureRandom.hex(6)}", paid_at: Time.current)
      confirm_payable(payment.payable)
      PaymentService::Result.new(payment: payment, redirect_url: nil, success: true)
    end

    def handle_webhook(_params, _headers)
      nil
    end

    private

    def confirm_payable(payable)
      case payable
      when Booking      then payable.update!(status: :paid)
      when Registration then payable.update!(status: :confirmed)
      when Subscription then payable.update!(status: :active, started_at: Time.current)
      end
    end
  end
end

# PaymentService — provider-agnostic payment interface.
#
# Real provider (Stripe / PayPal / local MENA gateway) is wired later by
# implementing a concrete adapter and registering it here. For now the
# null adapter records intent and immediately marks payments as paid so the
# booking / registration flow can be built and tested end to end.
#
# Usage:
#   result = PaymentService.checkout(payable: booking, user: current_user)
#   result.redirect_url  # where to send the customer (nil for the stub)
#   result.payment       # the persisted Payment record
class PaymentService
  Result = Struct.new(:payment, :redirect_url, :success, keyword_init: true) do
    def success? = success
  end

  class << self
    def adapter
      @adapter ||= adapter_class.new
    end

    attr_writer :adapter

    def adapter_class
      name = ENV.fetch("PAYMENT_PROVIDER", "null").to_s.camelize
      "PaymentAdapters::#{name}Adapter".constantize
    rescue NameError
      PaymentAdapters::NullAdapter
    end

    def provider_name
      adapter.provider_name
    end

    # Create a payment for the given payable and start the provider checkout.
    def checkout(payable:, user: nil, amount_cents: nil, currency: nil)
      amount_cents ||= payable.try(:total_cents) || payable.try(:amount_cents) || payable.try(:entry_fee_cents) || 0
      currency ||= payable.try(:currency) || Money.default_currency.iso_code

      payment = Payment.create!(
        payable: payable,
        user: user || payable.try(:user),
        amount_cents: amount_cents,
        currency: currency,
        status: :pending
      )

      adapter.start_checkout(payment)
    end

    # Provider webhook entry point. Returns the updated Payment or nil.
    def handle_webhook(params, headers = {})
      adapter.handle_webhook(params, headers)
    end
  end
end

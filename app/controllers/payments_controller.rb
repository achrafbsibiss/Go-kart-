class PaymentsController < ApplicationController
  # Provider webhook — no CSRF, no locale, no auth (verified by adapter).
  skip_before_action :verify_authenticity_token
  skip_before_action :set_locale

  def webhook
    PaymentService.handle_webhook(params, request.headers)
    head :ok
  end
end

class Payment < ApplicationRecord
  monetize :amount_cents, with_model_currency: :currency

  enum :status, { pending: 0, processing: 1, paid: 2, failed: 3, refunded: 4 }, default: :pending

  belongs_to :payable, polymorphic: true
  belongs_to :user, optional: true

  before_validation :assign_provider, on: :create

  scope :successful, -> { where(status: :paid) }

  private

  def assign_provider
    self.provider ||= PaymentService.provider_name
  end
end

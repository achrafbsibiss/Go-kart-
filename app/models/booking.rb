class Booking < ApplicationRecord
  monetize :total_cents, with_model_currency: :currency, allow_nil: true

  enum :status, { pending: 0, confirmed: 1, paid: 2, completed: 3, canceled: 4, no_show: 5 }, default: :pending

  belongs_to :user
  belongs_to :session_price, optional: true
  belongs_to :kart_type, optional: true
  has_many :payments, as: :payable, dependent: :nullify

  validates :starts_at, presence: true
  validates :party_size, numericality: { greater_than: 0 }

  before_validation :assign_reference, on: :create
  before_validation :set_total, on: :create

  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }

  private

  def assign_reference
    self.reference ||= "BK-#{SecureRandom.alphanumeric(8).upcase}"
  end

  def set_total
    return if total_cents.present? || session_price.nil?

    self.total_cents = session_price.price_cents.to_i * party_size.to_i
    self.currency ||= session_price.currency
  end
end

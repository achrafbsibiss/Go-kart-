class SessionPrice < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  monetize :price_cents, with_model_currency: :currency

  enum :category, { solo: 0, group_session: 1, kids: 2, arrive_drive: 3, endurance: 4, vip: 5 }

  belongs_to :kart_type, optional: true
  has_many :bookings, dependent: :restrict_with_error

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, price_cents: :asc) }
end

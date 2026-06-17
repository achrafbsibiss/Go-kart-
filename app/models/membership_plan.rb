class MembershipPlan < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  monetize :price_cents, with_model_currency: :currency

  enum :period, { monthly: 0, quarterly: 1, yearly: 2 }

  has_many :subscriptions, dependent: :restrict_with_error

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, price_cents: :asc) }

  def benefit_list
    Array(benefits).flatten.compact_blank
  end
end

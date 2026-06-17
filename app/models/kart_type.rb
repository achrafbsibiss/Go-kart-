class KartType < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum :category, { kids: 0, junior: 1, adult: 2, pro: 3, electric: 4, twin: 5 }

  has_many :session_prices, dependent: :nullify
  has_many :race_entries, dependent: :nullify
  has_one_attached :photo
  has_many_attached :gallery

  store_accessor :specs, :tyres, :chassis, :brakes, :transmission, :acceleration

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, name: :asc) }
end

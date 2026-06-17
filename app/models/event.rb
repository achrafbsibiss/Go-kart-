class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum :kind, { event: 0, promotion: 1, party: 2, corporate: 3 }, default: :event

  has_many :registrations, as: :registerable, dependent: :destroy
  has_one_attached :banner

  validates :name, presence: true

  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }
  scope :featured, -> { where(featured: true) }
end

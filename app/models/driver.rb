class Driver < ApplicationRecord
  extend FriendlyId
  friendly_id :display_name, use: :slugged

  belongs_to :user, optional: true
  has_many :race_entries, dependent: :nullify
  has_many :laps, through: :race_entries
  has_many :best_laps, dependent: :destroy
  has_many :registrations, dependent: :nullify
  has_many :championship_standings, dependent: :destroy
  has_one_attached :avatar

  validates :nickname, presence: true

  scope :ranked, -> { order(points: :desc, best_lap_ms: :asc) }

  def display_name
    nickname.presence || user&.full_name || "Driver"
  end

  def best_lap_label
    Lap.format_ms(best_lap_ms)
  end
end

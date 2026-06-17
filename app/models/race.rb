class Race < ApplicationRecord
  enum :status, { scheduled: 0, live: 1, finished: 2, canceled: 3 }, default: :scheduled
  enum :race_type, { practice: 0, qualifying: 1, heat: 2, final: 3, endurance: 4 }, default: :heat

  belongs_to :competition, optional: true
  belongs_to :track, optional: true
  has_many :race_entries, dependent: :destroy
  has_many :laps, through: :race_entries
  has_many :best_laps, dependent: :nullify

  scope :live_now, -> { where(status: :live) }
  scope :recent, -> { order(scheduled_at: :desc) }

  # Live leaderboard ordered by laps completed then total time.
  def leaderboard
    race_entries
      .includes(:driver, :kart_type)
      .sort_by { |e| [-(e.laps_completed || 0), e.total_time_ms || Float::INFINITY] }
  end

  def fastest_entry
    race_entries.where.not(best_lap_ms: nil).order(:best_lap_ms).first
  end

  def turbo_stream_channel
    "race_#{id}"
  end
end

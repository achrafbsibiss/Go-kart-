class RaceEntry < ApplicationRecord
  enum :status, { registered: 0, on_track: 1, finished: 2, dnf: 3, dsq: 4 }, default: :registered

  belongs_to :race
  belongs_to :driver, optional: true
  belongs_to :kart_type, optional: true
  has_many :laps, dependent: :destroy

  validates :kart_number, presence: true

  scope :by_grid, -> { order(:grid_position) }

  def driver_name
    driver&.display_name || "Kart ##{kart_number}"
  end

  def best_lap_label
    Lap.format_ms(best_lap_ms)
  end

  def gap_to(leader)
    return "—" if leader.nil? || leader == self
    return "+#{(laps_completed.to_i - leader.laps_completed.to_i).abs} lap" if laps_completed.to_i < leader.laps_completed.to_i

    diff = (total_time_ms.to_i - leader.total_time_ms.to_i)
    diff.positive? ? "+#{(diff / 1000.0).round(3)}s" : "—"
  end

  # Recompute aggregates from laps; called after each new lap arrives.
  def recompute!
    completed = laps.count
    best = laps.minimum(:lap_time_ms)
    total = laps.sum(:lap_time_ms)
    update_columns(laps_completed: completed, best_lap_ms: best, total_time_ms: total)
  end
end

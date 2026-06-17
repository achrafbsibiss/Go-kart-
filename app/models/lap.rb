class Lap < ApplicationRecord
  belongs_to :race_entry
  has_one :race, through: :race_entry

  validates :lap_number, :lap_time_ms, presence: true

  scope :chronological, -> { order(:lap_number) }

  # Format milliseconds as a lap time string, e.g. 1:02.345
  def self.format_ms(ms)
    return "—" if ms.blank?

    total_seconds = ms / 1000.0
    minutes = (total_seconds / 60).floor
    seconds = total_seconds - minutes * 60
    format("%d:%06.3f", minutes, seconds)
  end

  def label
    self.class.format_ms(lap_time_ms)
  end
end

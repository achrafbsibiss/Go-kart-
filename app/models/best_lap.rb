class BestLap < ApplicationRecord
  belongs_to :driver
  belongs_to :track, optional: true
  belongs_to :kart_type, optional: true
  belongs_to :race, optional: true

  validates :lap_time_ms, presence: true

  scope :fastest, -> { order(:lap_time_ms) }
  scope :for_period, ->(range) { where(recorded_at: range) }
  scope :today,      -> { for_period(Time.current.all_day) }
  scope :this_week,  -> { for_period(Time.current.all_week) }
  scope :this_month, -> { for_period(Time.current.all_month) }

  def self.records
    {
      day:   today.fastest.first,
      week:  this_week.fastest.first,
      month: this_month.fastest.first,
      all:   fastest.first
    }
  end

  def label
    Lap.format_ms(lap_time_ms)
  end
end

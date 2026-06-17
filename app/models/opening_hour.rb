class OpeningHour < ApplicationRecord
  belongs_to :venue

  DAYS = %i[sunday monday tuesday wednesday thursday friday saturday].freeze

  validates :day_of_week, inclusion: { in: 0..6 }

  scope :ordered, -> { order(:day_of_week) }

  def day_name
    DAYS[day_of_week].to_s
  end

  def open_at?(at)
    return false if closed? || opens_at.blank? || closes_at.blank?

    minutes = at.hour * 60 + at.min
    open_min  = opens_at.hour * 60 + opens_at.min
    close_min = closes_at.hour * 60 + closes_at.min
    minutes.between?(open_min, close_min)
  end
end

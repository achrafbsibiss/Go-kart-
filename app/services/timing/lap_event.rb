module Timing
  # Normalized lap event every timing adapter produces, regardless of the
  # underlying hardware protocol (SMS-Timing, MyLaps/AMB, etc).
  LapEvent = Struct.new(
    :transponder_id, # string from the physical transponder, optional
    :kart_number,    # integer kart number, fallback identifier
    :lap_number,     # integer, optional (derived if nil)
    :lap_time_ms,    # integer milliseconds, required
    :sector_times,   # array of ms, optional
    :recorded_at,    # Time, defaults to now
    keyword_init: true
  ) do
    def recorded_at = self[:recorded_at] || Time.current
  end
end

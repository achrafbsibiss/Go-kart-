class RelaxOptionalForeignKeys < ActiveRecord::Migration[7.2]
  CHANGES = {
    races: %i[competition_id track_id],
    race_entries: %i[driver_id kart_type_id],
    best_laps: %i[track_id kart_type_id race_id],
    session_prices: %i[kart_type_id],
    drivers: %i[user_id],
    competitions: %i[track_id],
    bookings: %i[session_price_id]
  }.freeze

  def up
    CHANGES.each { |t, cols| cols.each { |c| change_column_null(t, c, true) } }
  end

  def down
    CHANGES.each { |t, cols| cols.each { |c| change_column_null(t, c, false) } }
  end
end

class TournamentMatch < ApplicationRecord
  belongs_to :competition
  belongs_to :driver_a, class_name: "Driver", optional: true
  belongs_to :driver_b, class_name: "Driver", optional: true
  belongs_to :winner,   class_name: "Driver", optional: true

  scope :for_round, ->(round) { where(round: round).order(:slot) }

  def decided?
    winner_id.present?
  end
end

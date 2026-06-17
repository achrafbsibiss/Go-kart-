class ChampionshipStanding < ApplicationRecord
  belongs_to :competition
  belongs_to :driver

  scope :ranked, -> { order(points: :desc, wins: :desc) }
end

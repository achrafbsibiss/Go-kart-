class Track < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :races, dependent: :nullify
  has_many :competitions, dependent: :nullify
  has_many :best_laps, dependent: :destroy
  has_one_attached :layout_image

  validates :name, presence: true
end

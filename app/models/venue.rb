class Venue < ApplicationRecord
  has_many :opening_hours, dependent: :destroy
  has_one_attached :hero_image
  has_many_attached :photos

  store_accessor :socials, :facebook, :instagram, :tiktok, :youtube, :x, :whatsapp

  validates :name, presence: true

  # Singleton-style accessor: the platform models one venue.
  def self.current
    first || new(name: "Karting Center")
  end

  def open_now?(at = Time.current)
    opening_hours.find_by(day_of_week: at.wday)&.open_at?(at) || false
  end
end

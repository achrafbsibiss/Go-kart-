class GalleryItem < ApplicationRecord
  enum :media_kind, { photo: 0, video: 1 }, default: :photo
  enum :category, { track: 0, karts: 1, events: 2, competitions: 3, facility: 4 }, default: :track

  has_one_attached :image

  validates :title, presence: true

  scope :ordered, -> { order(position: :asc, created_at: :desc) }
  scope :featured, -> { where(featured: true) }
end

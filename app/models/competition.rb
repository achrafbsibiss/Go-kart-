class Competition < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  monetize :entry_fee_cents, with_model_currency: :currency, allow_nil: true

  enum :format, { sprint: 0, endurance: 1, championship: 2, knockout: 3 }
  enum :status, { draft: 0, announced: 1, registration_open: 2, in_progress: 3, completed: 4, canceled: 5 }, default: :draft

  belongs_to :track, optional: true
  has_many :races, dependent: :nullify
  has_many :championship_standings, dependent: :destroy
  has_many :tournament_matches, dependent: :destroy
  has_many :registrations, as: :registerable, dependent: :destroy
  has_one_attached :banner

  validates :name, presence: true

  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }

  def accepting_registrations?(at = Time.current)
    status == "registration_open" &&
      (registration_opens_at.nil? || at >= registration_opens_at) &&
      (registration_closes_at.nil? || at <= registration_closes_at)
  end

  def spots_left
    return nil if capacity.blank?

    capacity - registrations.where.not(status: :canceled).count
  end
end

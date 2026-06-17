class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :membership_plan
  has_many :payments, as: :payable, dependent: :nullify

  enum :status, { pending: 0, active: 1, past_due: 2, canceled: 3, expired: 4 }, default: :pending

  scope :current, -> { where(status: :active).where("ends_at IS NULL OR ends_at > ?", Time.current) }
end

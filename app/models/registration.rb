class Registration < ApplicationRecord
  enum :status, { pending: 0, confirmed: 1, waitlisted: 2, canceled: 3 }, default: :pending

  belongs_to :user
  belongs_to :registerable, polymorphic: true
  belongs_to :driver, optional: true
  has_many :payments, as: :payable, dependent: :nullify

  before_validation :assign_reference, on: :create
  after_initialize { self.registered_at ||= Time.current if new_record? }

  scope :active, -> { where.not(status: :canceled) }

  private

  def assign_reference
    self.reference ||= "RG-#{SecureRandom.alphanumeric(8).upcase}"
  end
end

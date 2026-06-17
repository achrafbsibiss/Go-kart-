class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { customer: 0, staff: 1, admin: 2 }, default: :customer

  has_one  :driver, dependent: :nullify
  has_many :bookings, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :payments, dependent: :nullify
  has_many :notifications, dependent: :destroy
  has_one_attached :avatar

  LOCALES = %w[fr en ar].freeze

  validates :locale, inclusion: { in: LOCALES }

  def full_name
    [ first_name, last_name ].compact_blank.join(" ").presence || email.split("@").first
  end

  def staff_or_admin?
    staff? || admin?
  end
end

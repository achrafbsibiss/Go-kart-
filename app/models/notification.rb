class Notification < ApplicationRecord
  enum :kind, { race_start: 0, race_result: 1, event_reminder: 2, booking: 3, best_lap: 4, system: 5 }, default: :system

  belongs_to :user, optional: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :global, -> { where(broadcast: true) }

  def read?
    read_at.present?
  end

  # Push to the user's personal stream (or the global stream when broadcast).
  def deliver!
    target = broadcast? ? "notifications_all" : "notifications_user_#{user_id}"
    broadcast_prepend_later_to(target, target: "notifications", partial: "notifications/notification", locals: { notification: self })
  end
end

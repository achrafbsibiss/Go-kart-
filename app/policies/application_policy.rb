# frozen_string_literal: true

# Base policy for Action Policy. `user` is injected via the authorization
# context declared in ApplicationController (`authorize :user, through: :current_user`).
class ApplicationPolicy < ActionPolicy::Base
  # Default deny — override per-policy.
  default_rule :manage?

  def index?  = false
  def show?   = false
  def create? = false
  def update? = false
  def destroy? = false

  # Catch-all for any rule not explicitly defined.
  def manage? = staff_or_admin?

  private

  def staff_or_admin?
    user&.staff_or_admin?
  end

  # Relation scoping (Action Policy "scopes"), e.g. authorized_scope(Booking.all).
  relation_scope do |relation|
    relation
  end
end

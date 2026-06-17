class MembershipsController < ApplicationController
  def index
    @plans = MembershipPlan.active.ordered
  end
end

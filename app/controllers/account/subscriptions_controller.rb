module Account
  class SubscriptionsController < BaseController
    def index
      @subscriptions = current_user.subscriptions.includes(:membership_plan).order(created_at: :desc)
      @plans = MembershipPlan.active.ordered
    end

    def create
      plan = MembershipPlan.find(params[:membership_plan_id])
      subscription = current_user.subscriptions.create!(membership_plan: plan, status: :pending)
      PaymentService.checkout(payable: subscription, user: current_user)
      redirect_to account_subscriptions_path, notice: t("memberships.choose")
    end
  end
end

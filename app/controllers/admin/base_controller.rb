module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_staff!
    layout "admin"

    private

    def require_staff!
      redirect_to root_path, alert: t("errors.not_authorized") unless current_user&.staff_or_admin?
    end
  end
end

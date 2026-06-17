module Account
  class ProfilesController < BaseController
    def show
      @driver = current_user.driver
    end

    def edit; end

    def update
      if current_user.update(profile_params)
        redirect_to account_profile_path, notice: t("actions.save")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :phone, :locale, :marketing_opt_in, :avatar)
    end
  end
end

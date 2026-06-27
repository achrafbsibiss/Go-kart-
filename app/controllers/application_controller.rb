class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_venue, :rtl?

  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    candidate = params[:locale].presence ||
                current_user&.locale.presence ||
                cookies[:locale].presence ||
                http_accept_language
    candidate if I18n.available_locales.map(&:to_s).include?(candidate.to_s)
  end

  def http_accept_language
    request.env["HTTP_ACCEPT_LANGUAGE"].to_s.scan(/[a-z]{2}/).find do |lang|
      I18n.available_locales.map(&:to_s).include?(lang)
    end
  end

  def current_venue
    @current_venue ||= Venue.current
  end

  def rtl?
    I18n.locale.to_s == "ar"
  end

  def forbidden
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: t("errors.not_authorized", default: "Not authorized.") }
      format.json { head :forbidden }
    end
  end

  def require_admin!
    redirect_to root_path, alert: "Admins only." unless current_user&.staff_or_admin?
  end

  # Allow profile fields through Devise sign-up / account-update.
  def configure_permitted_parameters
    extra = %i[first_name last_name phone locale marketing_opt_in]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra)
    devise_parameter_sanitizer.permit(:account_update, keys: extra)
  end
end

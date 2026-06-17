# Serves the PWA manifest + service worker. Standalone (not ApplicationController)
# so the modern-browser gate and locale handling don't apply to these assets.
class PwaController < ActionController::Base
  skip_forgery_protection
  helper_method :current_venue

  def manifest
    render template: "pwa/manifest", layout: false, content_type: "application/manifest+json"
  end

  def service_worker
    render template: "pwa/service-worker", layout: false, content_type: "text/javascript"
  end

  private

  def current_venue
    @current_venue ||= Venue.current
  end
end

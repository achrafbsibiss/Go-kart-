class ContactController < ApplicationController
  def show
    @venue = current_venue
    @opening_hours = @venue.opening_hours.ordered
  end

  def create
    # Lead capture stub — wire to mailer / CRM later.
    redirect_to contact_path, notice: t("contact.sent")
  end
end

module Admin
  class RegistrationsController < ResourceController
    private

    def resource_scope
      Registration.includes(:user, :registerable).order(created_at: :desc)
    end

    def permitted_attributes
      %w[status]
    end
  end
end

module Admin
  class MembershipPlansController < ResourceController
    private

    def permitted_attributes
      [
      "name",
      "description",
      "price_cents",
      "currency",
      "period",
      "popular",
      "position",
      "active",
      ]
    end
  end
end

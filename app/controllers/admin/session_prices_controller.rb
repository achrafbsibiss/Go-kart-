module Admin
  class SessionPricesController < ResourceController
    private

    def permitted_attributes
      [
      "name",
      "description",
      "kart_type_id",
      "duration_minutes",
      "laps",
      "price_cents",
      "currency",
      "category",
      "position",
      "active",
      ]
    end
  end
end

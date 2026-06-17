module Admin
  class KartTypesController < ResourceController
    private

    def permitted_attributes
      [
      "name",
      "category",
      "description",
      "top_speed_kmh",
      "power_hp",
      "engine",
      "weight_kg",
      "min_age",
      "min_height_cm",
      "position",
      "active",
      "photo",
      ]
    end
  end
end

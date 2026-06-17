module Admin
  class TracksController < ResourceController
    private

    def permitted_attributes
      [
      "name",
      "description",
      "length_m",
      "corners",
      "surface",
      "layout_image",
      ]
    end
  end
end

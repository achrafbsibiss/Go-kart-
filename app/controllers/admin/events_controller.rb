module Admin
  class EventsController < ResourceController
    private

    def permitted_attributes
      [
      "name",
      "description",
      "kind",
      "starts_at",
      "ends_at",
      "location",
      "featured",
      "banner"
      ]
    end
  end
end

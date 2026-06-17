module Admin
  class CompetitionsController < ResourceController
    private

    def permitted_attributes
      [
      "name",
      "description",
      "format",
      "status",
      "starts_at",
      "ends_at",
      "registration_opens_at",
      "registration_closes_at",
      "capacity",
      "entry_fee_cents",
      "currency",
      "track_id",
      "banner"
      ]
    end
  end
end

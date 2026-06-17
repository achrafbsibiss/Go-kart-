module Admin
  class DriversController < ResourceController
    private

    def permitted_attributes
      [
      "user_id",
      "nickname",
      "transponder_id",
      "bio",
      "country",
      "total_races",
      "best_lap_ms",
      "points",
      "avatar"
      ]
    end
  end
end

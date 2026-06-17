module Admin
  class RacesController < ResourceController
    before_action :set_race, only: %i[start finish]

    def show
      @drivers = Driver.order(:nickname)
      @kart_types = KartType.ordered
      render "admin/races/show"
    end

    def start
      RaceManager.start!(@race)
      redirect_to admin_race_path(@race), notice: t("admin.start")
    end

    def finish
      RaceManager.finish!(@race)
      redirect_to admin_race_path(@race), notice: t("admin.finish")
    end

    private

    def set_race
      @race = Race.find(params[:id])
    end

    def permitted_attributes
      %w[name competition_id track_id status race_type scheduled_at total_laps]
    end
  end
end

module Admin
  class RaceEntriesController < BaseController
    def create
      @race = Race.find(params[:race_id])
      @race.race_entries.create!(race_entry_params)
      redirect_to admin_race_path(@race), notice: t("admin.entries")
    end

    def destroy
      @race = Race.find(params[:race_id])
      @race.race_entries.find(params[:id]).destroy
      redirect_to admin_race_path(@race)
    end

    private

    def race_entry_params
      params.require(:race_entry).permit(:driver_id, :kart_type_id, :kart_number, :transponder_id, :grid_position)
    end
  end
end

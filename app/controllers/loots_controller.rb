class LootsController < ApplicationController
    before_filter(:load_raid)
    before_filter(:load_character)

    def create
        @loot = Loot.new(params[:loot])
        @loot.raid = @raid
        @loot.save

        @list = List.get_list(CONFIG[:guild])
        @list.new_loot(@raid, @loot)

        @raid.reload

        @list = List.get_list_from_raid(CONIFG[:guild]), @raid)

        respond_to do |format|
            format.html { redirect_to raid_url(@raid) }
            format.js
        end
    end

    private

    def load_character
        @character = Character.find(params[:loot][:character_id])
    end

    def load_raid
        @raid = Raid.find(params[:raid_id])
    end
end

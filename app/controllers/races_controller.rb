class RacesController < ApplicationController
    before_filter(:load_race, :only => [:edit, :destroy])
    before_filter(:load_races, :only => [:index])
    before_filter(:load_factions, :only => [:index, :edit, :create])

    def index
        respond_to do |format|
            format.html
            format.js
        end
    end

    def edit
        respond_to do |format|
            format.js
        end
    end

    def create
        @race = Race.new(params[:race])
        @race.save

        respond_to do |format|
            format.html { redirect_to(races_url) }
            format.js
            format.xml { render(:xml => @race.to_xml) }
        end
    end

    def update
        @race = Race.update(params[:id], params[:race])

        respond_to do |format|
            format.html { redirect_to(admin_races_url) }
            format.js
            format.xml { render(:xml => @race.to_xml) }
        end
        load_races

        render :update do |page|
            page[:races].replace_html render :partial => "lists/race", :collection => @races
        end
    end

    def destroy
        @race.destroy

        respond_to do |format|
            format.html { redirect_to(races_url) }
            format.js
        end
    end

    private

    def load_race
        @race = Race.find(params[:id])
    end

    def load_races
        @races = Race.find(:all, :order => "factions.name, races.name", :include => :faction)
    end

    def load_factions
        @factions = Faction.find(:all, :order => :name)
    end
end

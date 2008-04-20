class SignupsController < ApplicationController
    before_filter(:load_raid, :only => [:create, :destroy])
    before_filter(:load_signup, :only => :destroy)
    cache_sweeper :signup_sweeper, :only => [:create, :update, :destroy]

    def create
        @signup = Signup.new(params[:signup])
        @signup.raid = @raid
        @signup.save

        respond_to do |format|
            format.html { redirect_to raid_url(@raid) }
        end
    end

    def destroy
        @signup.destroy

        respond_to do |format|
            format.html { redirect_to raid_url(@raid) }
        end
    end        
    
    def update_char_slot_types
        @character = Character.find(params[:id])
        render :update do |page|
            page[params[:div]].replace_html(render(:partial => "character_slot_types",
                                                   :locals => { :character => @character }))
        end
    end

    private

    def load_raid
        @raid = Raid.find(params[:raid_id])
    end

    def load_signup
        @signup = @raid.signups.find(params[:id])
    end
end

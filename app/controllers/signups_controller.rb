class SignupsController < ApplicationController
    def update_char_slot_types
        @character = Character.find(params[:id])
        render :update do |page|
            page[params[:div]].replace_html(render(:partial => "character_slot_types",
                                                   :locals => { :character => @character }))
        end
    end
end

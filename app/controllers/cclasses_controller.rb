class CclassesController < ApplicationController
    before_filter(:load_cclasses, :only => [:index])
    before_filter(:load_cclass, :only => [:edit, :destroy])
    before_filter(:load_races, :only => [:index, :edit, :create])

    def index
        respond_to do |format|
            format.html
            format.xml { render :xml => @cclasses.to_xml }
        end
    end

    def edit
        respond_to do |format|
            format.js
        end
    end

    def create
        @cclass = Cclass.new(params[:cclass])

        if @cclass.save
            respond_to do |format|
                format.html { redirect_to(cclasses_url) }
                format.js
                format.xml { render(:xml => @cclass.to_xml) }
            end
        else
            respond_to do |format|
                format.html { redirect_to(cclasses_url) }
                format.js do
                    render(:update) do |page|
                        page[:error].replace_html("Couldn't save new Cclass")
                        page[:error].appear
                        page.delay(5) do
                            page[:error].fade
                        end
                    end
                end                        
                format.xml { render(:xml => @cclass.to_xml) }
            end
        end               
    end

    def update
        @cclass = Cclass.update(params[:id], params[:cclass])

        respond_to do |format|
            format.html { redirect_to(cclasses_url) }
            format.js
        end
    end

    def destroy
        @cclass.destroy

        respond_to do |format|
            format.html { redirect_to(cclasses_url) }
            format.js
        end
    end

    private

    def load_cclasses
        @cclasses = Cclass.order('name')
    end

    def load_cclass
        @cclass = Cclass.find(params[:id])
    end

    def load_races
        @races = Race.all
    end
end

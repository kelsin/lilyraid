class RaidsController < ApplicationController
    before_filter(:load_raid, :only => [:show])

    def index
        @old = params[:old]

        if @old
            @raids = Raid.find(:all,
                               :include => [:instance, { :slots => [:cclass, :signup, :slot_type] }],
                               :conditions => ["raids.date < now()"],
                               :order => "raids.date desc")
        else
            @raids = Raid.find(:all,
                               :include => [:instance, { :slots => [:cclass, :signup, :slot_type] }],
                               :conditions => ["raids.date >= now()"],
                               :order => "raids.date")
        end

        respond_to do |format|
            format.html
        end
    end

    def show
        @signups = @raid.signups.select do |signup|
            signup.character.account == @current_account
        end

        @list = List.get_list("Master")

        @signup = Signup.new(:raid => @raid)
        
        if !@raid.started?
            @characters = @current_account.active_characters.select do |char|
                char.can_join(@raid)
            end
        end

        if @current_account.admin
            @admin_signup = Signup.new(:raid => @raid)
            @admin_characters = Character.find(:all,
                                               :order => "characters.name",
                                               :include => [:instances, :raids],
                                               :conditions => ["inactive = ?", false]).select do |character|
                character.can_join(@raid)
            end
        end
    end

    def edit
        @raid = Raid.find(params[:id])

        if @current_account == @raid.account or @current_account.admin
            @slot_types = SlotType.find(:all)
            @cclasses = Cclass.find(:all)
            

            render :update do |page|
                page[:raid].replace_html :partial => "edit_raid"
            end
        else
            render :update do |page|
                page[:raid].replace_html "You are not authorized to edit this account"
            end
        end
    end

    def destroy
        if @current_account.can_edit(raid)
            @raid.destroy

            respond_to do |format|
                format.html { redirect_to raids_url }
                format.js
            end
        else
            flash[:error] = "You don't have permission to delete that raid"
            respond_to do |format|
                format.html { redirect_to raids_url }
                format.js { redirect_to raids_url }
            end
        end        
    end

    def instance_levels
        instance = Instance.find(params[:id])
        
        render :update do |page|
            page[:raid_min_level].value = instance.min_level
            page[:raid_max_level].value = instance.max_level
            page[:level_loading].replace_html ""
        end
    end

    def new
        @instances = Instance.find(:all, :order => "name")
        @raid_templates = RaidTemplate.find(:all)
        @raid = Raid.new
        @raid.min_level = @instances[0].min_level
        @raid.max_level = @instances[0].max_level
        @raid.date = Time.now unless @raid.date
    end

    def create
        # Create raid object
        @raid = Raid.new(params[:raid])
        @raid.account = @current_account
        
        if @raid.save
            flash[:notice] = 'Raid saved!'
            redirect_to raid_url(@raid)
        else
            @instances = Instance.find(:all, :order => "name")
            @raid_templates = RaidTemplate.find(:all)
            render :action => 'new'
        end
    end

    private

    def load_raid
        @raid = Raid.find(params[:id],
                          :include => [{:characters => :account},
                                       {:slots => [{:signup => [{:character => [:cclass,
                                                                                :account]},
                                                                :roles]},
                                                   :role,
                                                   :cclass,
                                                   :raid]},
                                       {:signups => [{:character => [:cclass,
                                                                     :account]},
                                                     :roles]},
                                       :account,
                                       :instance,
                                       :loots])
    end
end

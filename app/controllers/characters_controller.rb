class CharactersController < ApplicationController
    before_filter(:load_account)
    before_filter(:load_character, :only => [:destroy, :edit])

    def create
        if @current_account == @account
            @character = Character.new(params[:character])
            @character.account = @account
            @character.save
        end

        @new_character = Character.new(:account => @account)
        @instances = Instance.find(:all,
                                   :conditions => ["requires_key = ?", true],
                                   :order => "name")
        @cclasses = Cclass.find(:all)
        @races = Race.find(:all)
        
        respond_to do |format|
            format.html { redirect_to account_url(@account) }
            format.js
        end
    end

    def edit
        if @current_account == @account
            @instances = Instance.find(:all,
                                       :conditions => ["requires_key = ?", true],
                                       :order => "name")
            @cclasses = Cclass.find(:all)
            @races = Race.find(:all)

            respond_to do |format|
                format.html
                format.js
            end
        else
            respond_to do |format|
                format.html { redirect_to account_url(@account) }
                format.js do
                    render :update do |page|
                        page.redirect_to(account_url(@account))
                    end
                end
            end
        end
    end

    def update
        if @current_account == @account
            @character = Character.update(params[:id], params[:character])
        end

        respond_to do |format|
            format.html { redirect_to account_url(@account) }
            format.js
        end
    end

    def destroy
        @character.destroy if @current_account == @account

        respond_to do |format|
            format.html { redirect_to account_url(@account) }
            format.js
        end
    end

    def roles
        @character = Character.find(params[:id])

        respond_to do |format|
            format.js { render(:partial => "characters/roles",
                               :locals => { :character => @character }) }
        end
    end

    private

    def load_account
        @account = Account.find(params[:account_id])
    end

    def load_character
        @character = @account.characters.find(params[:id])
    end
end

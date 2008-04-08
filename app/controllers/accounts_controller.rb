class AccountsController < ApplicationController
    before_filter(:load_account, :only => [:show, :edit, :create])
    before_filter(:load_accounts, :only => [:index])

    def index
    end

    def show
        if @current_account == @account
            @character = Character.new(:account => @account)
            @instances = Instance.find(:all,
                                       :conditions => ["requires_key = ?", true],
                                       :order => "name")
            @cclasses = Cclass.find(:all)
            @races = Race.find(:all)
        end

        respond_to do |format|
            format.html
        end
    end

    def edit
        if @current_account == @account
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
        if @current_account.id == params[:id]
            @account = Account.update(params[:id], params[:account])
        else
            load_account
        end

        respond_to do |format|
            format.html { redirect_to account_url(@account) }
            format.js
        end
    end

    private

    def load_account
        @account = Account.find(params[:id],
                                :include => { :characters => [:cclass,
                                                              :race,
                                                              :raids,
                                                              :instances,
                                                              :signups,
                                                              :account] } )
    end

    def load_accounts
        @admins = Account.admins
        @members = Account.members
    end                                 
end

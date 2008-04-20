class AccountsController < ApplicationController
    cache_sweeper :account_sweeper, :only => [:update]

    def show
        @account = Account.find(params[:id])
    end

    def edit
        @account = Account.find(params[:id],
                                :include => { :characters => [:cclass,
                                                              :race,
                                                              :raids,
                                                              :instances,
                                                              :signups,
                                                              :account] } )

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
        if @current_account.id == params[:id].to_i
            @account = Account.update(params[:id], params[:account])
        else
            @account = Account.find(params[:id])
        end

        respond_to do |format|
            format.html { redirect_to account_url(@account) }
            format.js
        end
    end

    private

    def index_cache_path
        if @current_account.admin?
            "/admin/accounts"
        else
            "/accounts"
        end
    end

    def show_cache_path
        path = ""
        if @current_account.admin? 
            path += "/admin"
        end

        if @current_account.id == params[:id].to_i
            path += "/accounts/#{params[:id]}/owner"
        else
            path += "/accounts/#{params[:id]}"
        end
    end
end

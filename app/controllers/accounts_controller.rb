class AccountsController < ApplicationController
  def show
    @account = Account.find(params[:id])
  end

  def add_to_list
    @list = List.get_list(CONFIG[:guild])

    @account = Account.find(params[:id])
    @list.add_to_end(@account)

    redirect_to raid_url(params[:raid])
  end

  def edit
    @account = Account.find(params[:id],
                            :include => { :characters => [:cclass,
                                                          :race,
                                                          :raids,
                                                          :instances,
                                                          :signups,
                                                          :account] } )

    if @current_account == @account || @current_account.admin
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
end

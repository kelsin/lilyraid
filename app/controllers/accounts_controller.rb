class AccountsController < ApplicationController
  def show
    @account = Account.find(params[:id])
  end

  def add_to_list
    @list = List.first

    @account = Account.find(params[:id])
    @lp = @list.add_to_end(@account)

    @raid = Raid.find(params[:raid_id])

    respond_to do |format|
      format.html { redirect_to @raid }
      format.js { render :template => false }
    end
  end

  def remove_from_list
    @list = List.first
    @account = Account.find(params[:id])

    lp = @list.find(@account)
    lp.destroy

    redirect_to lists_url
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
        format.js { render :template => false }
      end
    else
      respond_to do |format|
        format.html { redirect_to account_url(@account) }
        format.js do
          render :js => "window.location = '#{account_url(@account)}';"
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

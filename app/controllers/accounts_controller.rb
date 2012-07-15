class AccountsController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :create]

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new(:name => params[:name])
  end

  def create
    @account = Account.new(params[:account])

    if params[:creation_password] == CONFIG[:account_creation_password]
      if @account.save
        redirect_to account_url(@account)
      else
        render :action => "new"
      end
    else
      @account.errors.add(:base, 'Wrong account creation password')
      render :action => "new"
    end
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
                                                          :signups,
                                                          :account] } )

    if @current_account == @account || @current_account.admin
      respond_to do |format|
        format.html
        format.js { render :layout => false }
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
    if @current_account.admin || @current_account.id == params[:id].to_i
      @account = Account.update(params[:id], params[:account])
      respond_to do |format|
        format.html
        format.js { render :layout => false }
      end
    else
      @account = Account.find(params[:id])
      respond_to do |format|
        format.html { redirect_to account_url(@account) }
        format.js { render :layout => false }
      end
    end
  end
end

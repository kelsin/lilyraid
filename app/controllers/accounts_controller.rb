class AccountsController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :create]

  def index
    authorize! :read, Account
    @admins = Account.admins
    @members = Account.members
  end

  def show
    @account = Account.find(params[:id])
    authorize! :read, @account

    if can? :update, @account
      @character = Character.new(:account => @account)
    end
  end

  def new
    @account = Account.new(:name => params[:name])
    authorize! :create, Account
  end

  def create
    @account = Account.new(params[:account])
    authorize! :create, Account

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
                            :include => { :characters => [:raids,
                                                          :signups,
                                                          :account] } )
    authorize! :update, @account

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
    @account = Account.find(params[:id],
                            :include => { :characters => [:raids,
                                                          :signups,
                                                          :account] } )
    authorize! :update, @account

    if @account.update_attributes(params[:account])
      respond_to do |format|
        format.html { redirect_to account_url(@account) }
        format.js { render :layout => false }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end
end

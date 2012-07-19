class Admin::AccountsController < ApplicationController
  before_filter :require_admin

  def index
    authorize! :update, Account
    @accounts = Account.order('name').all
    @account = Account.new
    @character = Character.new
    @deletable = Account.order('name').all.select do |account|
      account.can_delete?
    end
  end

  def create
    authorize! :create, Account

    @account = Account.new(params[:account])
    if @account.save
      redirect_to admin_accounts_url
    else
      @accounts = Account.order('name').all
      @character = Character.new
      @deletable = Account.order('name').all.select do |account|
        account.can_delete?
      end

      render :action => "index"
    end
  end

  def rename
    Account.update(params[:id], params[:account])

    redirect_to admin_accounts_url
  end

  def destroy
    @account = Account.find(params[:id])
    authorize! :destroy, @account

    @account.destroy

    redirect_to accounts_url
  end
end

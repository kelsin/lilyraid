class Admin::AccountsController < ApplicationController
  before_filter :require_admin

  def index
    @accounts = Account.find(:all, :order => :name)

    @account = Account.new
    @character = Character.new
    @cclasses = Cclass.find(:all, :order => :name)
    
    @deletable = Account.find(:all, :order => :name).select do |account|
      account.can_delete
    end
  end

  def create
    @account = Account.new(params[:account])
    @account.save
    
    @character = Character.new(params[:character])
    @character.account = @account
    @character.save

    redirect_to account_url(@account.id)
  end

  def rename
    Account.update(params[:id], params[:account])
    
    redirect_to admin_accounts_url
  end

  def destroy
    Account.find(params[:id]).destroy

    redirect_to accounts_url
  end
end

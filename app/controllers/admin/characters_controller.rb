class Admin::CharactersController < ApplicationController
  def index
    @accounts = Account.find(:all, :order => :name)

    @account = Account.new
    @character = Character.new
    @cclasses = Cclass.find(:all, :order => :name)
  end

  def create
    @account = Account.new(params[:account])
    @account.save
    
    @character = Character.new(params[:character])
    @character.account = @account
    @character.save

    redirect_to account_url(@account.id)
  end
end

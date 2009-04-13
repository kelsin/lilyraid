class Admin::CharactersController < ApplicationController
  def index
    @accounts = Account.find(:all, :order => :name)

    @account = Account.new
    @character = Character.new
  end
end

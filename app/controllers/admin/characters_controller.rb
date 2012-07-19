class Admin::CharactersController < ApplicationController
  def create
    @account = Account.find(params[:character][:account_id])

    authorize! :edit, @account
    @character = Character.new(params[:character])
    @character.update_from_armory!

    redirect_to admin_accounts_url
  end
end

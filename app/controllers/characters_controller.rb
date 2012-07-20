class CharactersController < ApplicationController
  before_filter(:load_account, :except => [:roles, :index])
  before_filter(:load_character, :only => [:destroy, :edit, :update])

  def index
    authorize! :read, Character
    @characters = Character.order(:guild, :officer, :name).all
  end

  def new
    authorize! :edit, @account
    @character = @account.characters.build(:realm => CONFIG[:realm])
  end

  def create
    authorize! :edit, @account
    @character = @account.characters.build(params[:character])
    @character.update_from_armory!

    respond_to do |format|
      format.html { redirect_to account_url(@account) }
      format.js
    end
  end

  def edit
    authorize! :update, @character

    respond_to do |format|
      format.html
      format.js { render :template => false }
    end
  end

  def update
    authorize! :update, @character
    @character.attributes = params[:character]
    @character.update_from_armory!

    respond_to do |format|
      format.html { redirect_to account_url(@account) }
      format.js
    end
  end

  def destroy
    authorize! :destroy, @character
    @character.destroy

    respond_to do |format|
      format.html { redirect_to account_url(@account) }
      format.js { render :template => false }
    end
  end

  def roles
    @character = Character.find(params[:id])

    respond_to do |format|
      format.js { render(:partial => "raids/role", :collection => @character.cclass.roles) }
    end
  end

  private

  def load_account
    @account = Account.find(params[:account_id])
  end

  def load_character
    @character = @account.characters.find(params[:id])
  end
end

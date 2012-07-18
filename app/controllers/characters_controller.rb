class CharactersController < ApplicationController
  before_filter(:load_account, :except => [:roles])
  before_filter(:load_character, :only => [:destroy, :edit])

  def create
    if can? :edit, @account
      @character = @account.characters.create(params[:character])
      @character.update_from_armory!
    end

    respond_to do |format|
      format.html { redirect_to account_url(@account) }
      format.js
    end
  end

  def edit
    if @current_account.admin || @current_account == @account
      respond_to do |format|
        format.js { render :template => false }
      end
    else
      respond_to do |format|
        format.html { redirect_to account_url(@account) }
        format.js { render :js => "window.location = '#{account_url(@account)}';" }
      end
    end
  end

  def update
    if @current_account.admin || @current_account == @account
      @character = Character.update(params[:id], params[:character])
      @character.update_from_armory!
    end

    respond_to do |format|
      format.html { redirect_to account_url(@account) }
      format.js
    end
  end

  def destroy
    @character.destroy if @current_account.admin || @current_account == @account

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

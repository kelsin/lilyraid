class RaiderTagsController < ApplicationController
  def create
    @raid = Raid.find(params[:raid_id])
    @account = Account.find(params[:account_id])

    if @current_account.can_edit? @raid
      @raider_tag = @account.raider_tags.create(params[:raider_tag][params[:signup_id]].merge({ :raid_id => @raid.id }))
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @raid = Raid.find(params[:raid_id])
    @account = Account.find(params[:account_id])
    @raider_tag = @raid.raider_tags.for_account(@account).find(params[:id])

    if @current_account.can_edit? @raid
      @raider_tag.destroy
    end

    respond_to do |format|
      format.js
    end
  end
end

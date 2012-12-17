class RaiderTagsController < ApplicationController
  before_filter :require_admin

  def create
    @raid = Raid.find(params[:raid_id])
    @account = Account.find(params[:account_id])

    @raider_tag = @account.raider_tags.create(params[:raider_tag][params[:signup_id]].merge({ :raid_id => @raid.id }))

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def destroy
    @raid = Raid.find(params[:raid_id])
    @account = Account.find(params[:account_id])
    @raider_tag = @raid.raider_tags.for_account(@account).find(params[:id])

    @raider_tag.destroy

    respond_to do |format|
      format.js { render :layout => false }
    end
  end
end

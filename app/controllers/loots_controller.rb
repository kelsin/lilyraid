require 'net/http'

class LootsController < ApplicationController
  before_filter :load_raid, :except => :search
  before_filter :load_character, :only => :create
  before_filter :require_admin, :except => :search

  def create
    @list = List.first

    @loot = Loot.new(params[:loot])
    @loot.raid = @raid
    @loot.list = @list
    @loot.save

    loot_log(@loot, "Loot assigned (Was in position #{ListPosition.for_account(@loot.character.account).first.position})")

    @list.new_loot(@raid, @loot)

    @raid.reload

    @list = List.first

    respond_to do |format|
      format.html { redirect_to raid_url(@raid) }
      format.js
    end
  end

  def edit
    @loot = Loot.find(params[:id])
  end

  def update
    @loot = Loot.find(params[:id])
    @loot.update_attributes(params[:loot]) ? redirect_to(raid_url(@raid)) : render(:action => :edit)
  end

  def search
    if params[:search].blank?
      render :json => "['',[]]"
    else
      render :json => Net::HTTP.get('www.wowhead.com', "/search?q=#{CGI::escape(params[:search])}&opensearch")
    end
  end

  private

  def load_character
    @character = Character.find(params[:loot][:character_id])
  end

  def load_raid
    @raid = Raid.find(params[:raid_id])
  end
end

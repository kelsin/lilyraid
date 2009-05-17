class LootsController < ApplicationController
  before_filter :load_raid
  before_filter :load_character, :only => :create
  before_filter :require_admin

  def create
    @loot = Loot.new(params[:loot])
    @loot.raid = @raid
    @loot.save

    @list = List.first
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

  private

  def load_character
    @character = Character.find(params[:loot][:character_id])
  end

  def load_raid
    @raid = Raid.find(params[:raid_id])
  end
end

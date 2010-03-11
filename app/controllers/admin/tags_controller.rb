class Admin::TagsController < ApplicationController
  def create
    Tag.create(params[:tag])

    redirect_to raid_url(params[:raid_id])
  end
end

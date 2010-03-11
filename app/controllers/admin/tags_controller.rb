class Admin::TagsController < ApplicationController
  before_filter :require_admin

  def create
    Tag.create(params[:tag])

    redirect_to admin_accounts_path
  end

  def destroy
    Tag.destroy(params[:id])

    redirect_to admin_accounts_path
  end
end

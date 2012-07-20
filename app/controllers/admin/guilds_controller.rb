class Admin::GuildsController < ApplicationController
  def index
    authorize! :read, Guild
    @guilds = Guild.order(:name).all
  end

  def new
    authorize! :create, Guild
    @guild = Guild.new(:realm => CONFIG[:realm])
  end

  def create
    authorize! :create, Guild
    @guild = Guild.new(params[:guild])
    @changes = @guild.update_from_armory!

    if @changes.empty?
      redirect_to admin_guilds_path, :notice => "#{@guild} was updated and no changes needed to be made to members."
    else
      render :update
    end
  end

  def edit
    @guild = Guild.find(params[:id])
    authorize! :update, @guild
  end

  def update
    @guild = Guild.find(params[:id])
    authorize! :update, @guild

    @guild.attributes = params[:guild]
    @changes = @guild.update_from_armory!

    if @changes.empty?
      redirect_to admin_guilds_path, :notice => "#{@guild} was updated and no changes needed to be made to members."
    end
  end
end

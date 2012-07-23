class ListsController < ApplicationController
  before_filter(:load_list, :only => [:show, :edit, :update])

  def index
    authorize! :read, List
    @lists = List.all
    @list = List.new
  end

  def show
    authorize! :read, @list
  end

  def edit
    authorize! :update, @list
  end

  def update
    authorize! :update, @list

    if @list.update_attributes(params[:list])
      redirect_to lists_path
    else
      render :edit
    end
  end

  def create
    authorize! :create, List

    @list = List.new(params[:list])
    if @list.save
      redirect_to lists_path
    else
      @lists = List.all
      render :index
    end
  end

  private

  def load_list
    @list = List.find(params[:id])
  end
end

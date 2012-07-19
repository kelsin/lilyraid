class ListsController < ApplicationController
  before_filter(:load_list, :only => [:show])

  def index
    authorize! :read, List
    @lists = List.all
    @list = List.new
  end

  def show
    authorize! :read, @list
  end

  def create
    authorize! :create, List

    @list = List.new(params[:list])
    if @list.save
      respond_to do |format|
        format.html { redirect_to list_url(@list) }
        format.js
      end
    else
      respond_to do |format|
        format.html do
          @lists = List.all
          render :index
        end
        format.js
      end
    end
  end

  private

  def load_list
    @list = List.find(params[:id])
  end
end

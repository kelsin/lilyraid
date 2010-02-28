class Admin::TemplatesController < ApplicationController
  before_filter :require_admin

  def index
    @templates = Template.all
    @new_template = Template.new(:number_of_slots => 10)
  end

  def create
    @new_template = Template.new(params[:template])

    if @new_template.save
      redirect_to edit_admin_template_url(@new_template)
    else
      @templates = Template.all
      render :action => :index
    end
  end

  def edit
    @raid_template = Template.find(params[:id])
  end

  def update
    @raid_template = Template.find(params[:id])
    @raid_template.update_attributes(params[:template]) ? redirect_to(admin_templates_url) : render(:action => :edit)
  end    

  def destroy
    Template.destroy(params[:id])
    redirect_to admin_templates_url
  end
end

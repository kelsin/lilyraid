class Admin::TemplatesController < ApplicationController
  before_filter :require_admin

  def index
    @templates = Template.all
    @new_template = Template.new
  end

  def create
    @new_template = Template.new(params[:template])
    @new_template.save

    params[:slots].to_i.times do
      @new_template.slots.build.save
    end
    
    redirect_to edit_admin_template_url(@new_template)
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

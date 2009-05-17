class Admin::InstancesController < ApplicationController
  before_filter :require_admin

  def index
    @active = Instance.active.all
    @inactive = Instance.inactive.all
    @new_instance = Instance.new
  end

  def update
    @instance = Instance.find(params[:id])
    @instance.active = !@instance.active
    @instance.save

    redirect_to admin_instances_url
  end    

  def create
    @new_instance = Instance.new(params[:instance])
    @new_instance.save

    redirect_to admin_instances_url
  end

  def destroy
    Instance.destroy(params[:id])
    redirect_to admin_instances_url
  end
end

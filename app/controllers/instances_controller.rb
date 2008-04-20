class InstancesController < ApplicationController
    before_filter(:new_instance, :only => [:index, :create])
    before_filter(:load_instances, :only => [:index])
    before_filter(:load_instance, :only => [:edit, :destroy])

    cache_sweeper :instance_sweeper, :only => [:create, :update, :destroy]

    def index
        respond_to do |format|
            format.html
            format.xml { render :xml => @instances.to_xml }
        end
    end

    def edit
        respond_to do |format|
            format.js
        end
    end

    def create
        @new_instance = Instance.new(params[:instance])
        @new_instance.save

        respond_to do |format|
            format.html { redirect_to(instances_url) }
            format.js
            format.xml { render(:xml => @new_instance.to_xml) }
        end
    end

    def update
        @instance = Instance.update(params[:id], params[:instance])

        respond_to do |format|
            format.html { redirect_to(instances_url) }
            format.js
        end
    end

    def destroy
        @instance.destroy

        respond_to do |format|
            format.html { redirect_to(instances_url) }
            format.js
        end
    end

    private

    def new_instance
        @instance = Instance.new
    end

    def load_instances
        @instances = Instance.find(:all, :order => :name)
    end

    def load_instance
        @instance = Instance.find(params[:id])
    end
end

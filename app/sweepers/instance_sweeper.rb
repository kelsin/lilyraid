class InstanceSweeper < ActionController::Caching::Sweeper
    observe Instance
    
    def after_save(instance)
        expire_cache(instance)
    end

    def after_destroy(instance)
        expire_cache(instance)
    end

    def expire_cache(instance)
        expire_fragment :controller => "raids", :action => "new"

        Raid.in_instance(instance).each do |raid|
            expire_fragment(:controller => "raids",
                            :action => "show",
                            :id => raid.id,
                            :type => "admin_add")
        end
    end
end

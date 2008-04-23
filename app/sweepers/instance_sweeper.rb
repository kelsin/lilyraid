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
        expire_fragment(%r"/raids/.*\?type=admin_add")
    end
end

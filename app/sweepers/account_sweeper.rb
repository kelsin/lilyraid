class AccountSweeper < ActionController::Caching::Sweeper
    observe Account
    
    def after_save(account)
        expire_cache(account)
    end

    def after_destroy(account)
        expire_cache(account)
    end

    def expire_cache(account)
        expire_fragment :controller => "accounts", :action => "index"
        expire_fragment(%r"/raids/.*\?type=admin_add")
    end
end

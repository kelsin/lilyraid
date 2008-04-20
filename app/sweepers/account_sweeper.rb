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

        Raid.find(:all).each do |raid|
            expire_fragment(:controller => "raids",
                            :action => "show",
                            :id => raid.id,
                            :type => "admin_add")
        end
    end
end

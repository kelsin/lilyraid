class RaidSweeper < ActionController::Caching::Sweeper
    observe Raid
    
    def after_save(raid)
        expire_cache(raid)
    end

    def after_destroy(raid)
        expire_cache(raid)
    end

    def expire_cache(raid)
        Account.find(:all).each do |account|
            expire_fragment(:controller => "raids",
                            :action => "show",
                            :id => raid.id,
                            :account => account.id)
        end
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => raid.id,
                        :type => "admin_add")        

        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => raid.id)
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => raid.id,
                        :can_edit => true,
                        :type => "signups")        
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => raid.id,
                        :can_edit => false,
                        :type => "signups")        
    end
end

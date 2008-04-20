class SignupSweeper < ActionController::Caching::Sweeper
    observe Signup
    
    def after_save(signup)
        expire_cache(signup)
    end

    def after_destroy(signup)
        expire_cache(signup)
    end

    def expire_cache(signup)
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => signup.raid_id)
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => signup.raid_id,
                        :account => signup.character.account)

        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => signup.raid.id,
                        :type => "admin_add")
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => signup.raid.id,
                        :type => "admin_remove")        

        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => signup.raid.id,
                        :can_edit => true,
                        :type => "signups")        
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => signup.raid.id,
                        :can_edit => false,
                        :type => "signups")        
    end
end

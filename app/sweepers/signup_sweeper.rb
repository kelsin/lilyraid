class SignupSweeper < ActionController::Caching::Sweeper
    observe Signup
    
    def after_save(signup)
        expire_cache(signup)
    end

    def after_destroy(signup)
        expire_cache(signup)
    end

    def expire_cache(signup)
        expire_fragment(%r"/raids/#{signup.raid.id}")
        expire_fragment(%r"/accounts/#{signup.character.account.id}")
    end
end

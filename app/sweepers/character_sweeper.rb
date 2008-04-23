class CharacterSweeper < ActionController::Caching::Sweeper
    observe Character
    
    def after_save(character)
        expire_cache(character)
    end

    def after_destroy(character)
        expire_cache(character)
    end

    def expire_cache(character)
        expire_fragment :controller => "accounts", :action => "index"
        expire_fragment(%r"/raids/.*\?type=admin_add")
        expire_fragment(%r"/accounts/#{character.account.id}")
    end
end

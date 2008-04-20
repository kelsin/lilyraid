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

        Raid.find(:all).each do |raid|
            expire_fragment(:controller => "raids",
                            :action => "show",
                            :id => raid.id,
                            :type => "admin_add")
        end
    end
end

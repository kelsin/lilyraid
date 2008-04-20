class LootSweeper < ActionController::Caching::Sweeper
    observe Loot
    
    def after_save(loot)
        expire_cache(loot)
    end

    def after_destroy(loot)
        expire_cache(loot)
    end

    def expire_cache(loot)
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => slot.raid.id,
                        :type => "loot")
    end
end

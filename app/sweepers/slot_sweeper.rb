class SlotSweeper < ActionController::Caching::Sweeper
    observe Slot
    
    def after_save(slot)
        expire_cache(slot)
    end

    def after_destroy(slot)
        expire_cache(slot)
    end

    def expire_cache(slot)
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => slot.raid.id,
                        :type => "new_loot")
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => slot.raid.id,
                        :type => "loot")
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => slot.raid.id,
                        :can_edit => true,
                        :type => "signups")        
        expire_fragment(:controller => "raids",
                        :action => "show",
                        :id => slot.raid.id,
                        :can_edit => false,
                        :type => "signups")        
    end
end

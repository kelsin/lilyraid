class Preference < ActiveRecord::Base
    def self.get_setting(key)
        pref = find_by_key(key)
        return pref ? pref.value : nil
    end
end

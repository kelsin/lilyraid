class Preference < ActiveRecord::Base
    def self.get_setting(key)
        return self.find_by_key(key).value
    end
end

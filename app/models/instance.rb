class Instance < ActiveRecord::Base
    has_many :raids, :dependent => :nullify
    has_many :attunements, :dependent => :destroy
    has_many :characters, :through => :attunements

    def name_with_number
        "#{name} - #{max_number} man"
    end

    def self.keyed
        find(:all,
             :conditions => ["requires_key = ?", true],
             :order => "name")
    end

    def self.all
        find(:all, :order => "name")
    end
end

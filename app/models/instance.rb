class Instance < ActiveRecord::Base
    has_many :raids, :dependent => :nullify
    has_many :attunements, :dependent => :destroy
    has_many :characters, :through => :attunements

    def name_with_number
        "#{name} - #{max_number} man"
    end
end

class Attunement < ActiveRecord::Base
    belongs_to :character
    belongs_to :instance
end

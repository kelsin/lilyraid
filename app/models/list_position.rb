class ListPosition < ActiveRecord::Base
    belongs_to :character
    belongs_to :list
end

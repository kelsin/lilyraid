class ListPosition < ActiveRecord::Base
    belongs_to :account
    belongs_to :list
end

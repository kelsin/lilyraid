class RaiderTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :raid
  belongs_to :account
end

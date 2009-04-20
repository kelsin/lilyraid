class Loot < ActiveRecord::Base
  belongs_to :list
  belongs_to :character
  belongs_to :raid

  default_scope :order => "created_at"
end

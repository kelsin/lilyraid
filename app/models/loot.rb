class Loot < ActiveRecord::Base
  belongs_to :list
  belongs_to :character

  belongs_to :location
  belongs_to :raid
  belongs_to :instance

  default_scope :order => "created_at"
end

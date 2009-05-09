class Location < ActiveRecord::Base
  belongs_to :raid
  belongs_to :instance
  has_many :loots

  def name
    instance.name
  end
end

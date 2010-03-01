class Race < ActiveRecord::Base
  has_many :characters

  def self.named(name)
    self.first(:conditions => { :name => name })
  end
end

class Instance < ActiveRecord::Base
  has_many :raids, :dependent => :nullify

  def name_with_number
    "#{name} - #{max_number} man"
  end
end

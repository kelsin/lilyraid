class RemoveBadDefaultNotes < ActiveRecord::Migration
  def self.up
    Signup.all(:conditions => { :note => "Note" }).each do |signup|
      signup.update_attribute(:note, nil)
    end
  end

  def self.down
  end
end

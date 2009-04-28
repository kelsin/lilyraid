class RemoveBadDefaultNotes < ActiveRecord::Migration
  def self.up
    Signup.find(:all, :conditions => { :note => "Note" }).each do |signup|
      signup.note = ""
      signup.save
    end
  end

  def self.down
  end
end

class FixUtcTimes < ActiveRecord::Migration
  def self.up
    Raid.all.each do |raid|
      raid.date = raid.date + 7.hours
      raid.save
    end
  end

  def self.down
    Raid.all.each do |raid|
      raid.date = raid.date - 7.hours
      raid.save
  end
end

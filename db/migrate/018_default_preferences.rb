class DefaultPreferences < ActiveRecord::Migration
  def self.up
    Preference.new({:key => 'guild', :value => 'Your Guild'}).save
    Preference.new({:key => 'forum', :value => 'http://forum.link'}).save
  end

  def self.down
    Preferences.destroy_all
  end
end

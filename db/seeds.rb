# Classes
[{ :name => 'Death Knight', :color => 'c41f3b' },
 { :name => 'Druid', :color => 'ff7d0a' },
 { :name => 'Mage', :color => '69ccf0' },
 { :name => 'Paladin', :color => 'f58cba' },
 { :name => 'Priest', :color => 'ffffff' },
 { :name => 'Rogue', :color => 'fff569' },
 { :name => 'Shaman', :color => '2459ff' },
 { :name => 'Hunter', :color => 'abd473' },
 { :name => 'Warlock', :color => '9482ca' },
 { :name => 'Warrior', :color => 'c79c6e' }].each do |class_attributes|
  Cclass.create(class_attributes)
end

# Races
['Blood Elf', 'Draenei', 'Dwarf', 'Gnome', 'Human', 'Night Elf', 'Orc', 'Tauren', 'Troll', 'Undead'].each do |name|
  Race.create(:name => name)
end

['DPS','Healer','Tank'].each do |name|
  Role.create(:name => name)
end

CclassRole.create(:cclass => Cclass.named('Druid'), :role => Role.named('DPS'))

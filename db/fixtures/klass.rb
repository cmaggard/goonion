%{Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior}.each do |k|
  Klass.find_or_create_by_name(k)
end

puts "Classes seeded."
[
"Human",
"Dwarf",
"Gnome",
"Night Elf",
"Draenei",
"Orc",
"Troll",
"Undead",
"Tauren",
"Blood Elf"
].each do |r|
  Race.find_or_create_by_name(r)
end

puts "Races seeded."
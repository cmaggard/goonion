["Male","Female"].each do |g|
  Gender.find_or_create_by_name(g)
end

puts "Genders seeded."
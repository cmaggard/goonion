namespace :db do
  desc "Seeds lookup tables"
  task :seed_lookup => :environment do
    ["klass","race","gender", "faction"].each do |f|
      load File.join(RAILS_ROOT, 'db', 'fixtures', f + '.rb')
    end
  end
end
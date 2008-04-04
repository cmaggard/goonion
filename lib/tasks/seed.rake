namespace :db do
  desc "Seeds lookup tables"
  task :seed => :environment do
    ["klass","race","gender", "faction", "profession"].each do |f|
      load File.join(RAILS_ROOT, 'db', 'fixtures', f + '.rb')
    end
  end
end
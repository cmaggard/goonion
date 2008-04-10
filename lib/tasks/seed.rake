namespace :db do
  desc "Seeds lookup tables"
  task :seed => :environment do
    fixtures_dir = File.join(RAILS_ROOT, 'db', 'fixtures')
    Dir.foreach(fixtures_dir) do |file|
      load File.join(fixtures_dir, file) unless File.directory?(File.join(fixtures_dir, file))
    end
  end
end
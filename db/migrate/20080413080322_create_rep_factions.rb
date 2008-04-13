class CreateRepFactions < ActiveRecord::Migration
  def self.up
    create_table :rep_factions do |t|
      t.string  :name
      t.timestamps
    end
  end

  def self.down
    drop_table :rep_factions
  end
end

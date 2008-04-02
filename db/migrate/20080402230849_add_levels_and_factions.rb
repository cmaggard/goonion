class AddLevelsAndFactions < ActiveRecord::Migration
  def self.up
    add_column :characters, :level, :integer
    add_column :characters, :faction_id, :integer
    add_column :guilds, :faction_id, :integer
  end

  def self.down
    remove_column :characters, :level
    remove_column :characters, :faction_id
    remove_column :guilds, :faction_id
  end
end

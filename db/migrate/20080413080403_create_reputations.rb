class CreateReputations < ActiveRecord::Migration
  def self.up
    create_table :reputations do |t|
      t.integer :character_id
      t.integer :rep_faction_id
      t.integer :level
      t.timestamps
    end
  end

  def self.down
    drop_table :reputations
  end
end

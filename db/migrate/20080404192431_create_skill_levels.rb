class CreateSkillLevels < ActiveRecord::Migration
  def self.up
    create_table :skill_levels do |t|
      t.integer :character_id
      t.integer :skill_id
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :skill_levels
  end
end

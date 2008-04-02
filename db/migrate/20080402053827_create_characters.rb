class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name
      t.integer :guild_id
      t.integer :server_id
      t.integer :race_id
      t.integer :gender_id
      t.integer :klass_id

      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end

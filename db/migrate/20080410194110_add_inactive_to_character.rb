class AddInactiveToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :inactive, :boolean, :default => false
  end

  def self.down
    remove_column :characters, :inactive
  end
end

class Faction < ActiveRecord::Base
  has_many :guilds
  has_many :characters
end

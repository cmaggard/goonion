class RepFaction < ActiveRecord::Base
  has_many :reputations
  has_many :characters, :through => :reputations
end

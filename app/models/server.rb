class Server < ActiveRecord::Base
  has_many :guilds
  has_many :characters
end

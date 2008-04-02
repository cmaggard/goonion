class Guild < ActiveRecord::Base
  belongs_to :server
  belongs_to :faction
  has_many :characters
end

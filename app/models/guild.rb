class Guild < ActiveRecord::Base
  belongs_to :server
  has_many :characters
end

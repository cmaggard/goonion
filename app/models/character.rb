class Character < ActiveRecord::Base
  belongs_to :server
  belongs_to :guild
  belongs_to :race
  belongs_to :gender
  belongs_to :klass
  
end
class Reputation < ActiveRecord::Base
  belongs_to :character
  belongs_to :rep_faction
end

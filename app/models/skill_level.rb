class SkillLevel < ActiveRecord::Base
  belongs_to :character
  belongs_to :skill
end

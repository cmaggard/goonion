class Profession < Skill
  has_many :skill_levels
  has_many :characters, :through => :skill_levels
end
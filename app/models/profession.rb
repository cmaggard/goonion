class Profession < Skill
  has_many :skill_levels, :foreign_key => "skill_id"
  has_many :characters, :through => :skill_levels
end
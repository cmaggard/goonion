class Character < ActiveRecord::Base
  belongs_to :server
  belongs_to :guild
  belongs_to :race
  belongs_to :gender
  belongs_to :klass
  belongs_to :faction

  has_many :skill_levels
  has_many :skills, :through => :skill_levels
  [Profession, Secondary, Weapon].each do |skill|
    has_many skill.to_s.downcase.pluralize.to_sym, :class_name => skill.to_s, 
            :source => :skill, :through => :skill_levels
  end
  has_many :reputations
  has_many :rep_factions, :through => :reputations
  
  [Gender, Race, Klass, Faction].each do |c|
    c.find(:all).each do |g|
      named_scope g.name.downcase.gsub(" ","_").to_sym,
        { :conditions => {c.to_s.downcase.pluralize + ".name" => g.name}, 
          :include => c.to_s.downcase.to_sym }
    end
  end
  
  [Guild, Server].each do |c|
    named_scope c.name.downcase.to_sym,
      lambda { |n| { :conditions => {c.to_s.downcase.pluralize + ".name" => n},
                     :include => c.to_s.downcase.to_sym } }
  end
  
  named_scope :named, lambda { |n| { :conditions => {"name" => n} } }

  { "" => "=", "min_" => ">=", "max_" => "<="}.each do |k, v|
    named_scope( (k+"level").to_sym,
      lambda { |l| { :conditions => [["level",v].join(" ") + " ?", l] } })
  end
  
  Skill.find(:all).collect(&:name).each do |sk|
    { "" => "=", "min_" => ">=", "max_" => "<="}.each do |k, v|
      named_scope( (k+sk).downcase.gsub(/[-\s]/,"_").to_sym, 
        lambda { |l| { :include => [:skills],
                       :conditions => ["skills.name = ? AND skill_levels.level " + v  + " ?", sk, l ] } } )
    end 
  end
  
  # Returns true if character is played by an active account as determined
  # by Armory parse.
  def active?
    !inactive
  end
  
  # skill_hash is :skill_name => level
  def add_skills(skill_hash)
    char_skill_levels = self.skill_levels
    
    update_hash = Hash.new
    
    # For each character skill_level, index the 
    # skill_level object with the skill name
    char_skill_levels.each do |sk|
      update_hash[sk.skill.name] = sk
    end

    skill_hash.each do |name, value|
      begin
        update_hash[name].level = value
      rescue NoMethodError
        sk = Skill.find_by_name( name )
        sl = SkillLevel.new
        sl.level = value
        sl.skill = sk
        skill_levels << sl
      end
    end
    
    update_hash.each do |k,v|
      v.save if v.changed?
    end
  end
end
class Character < ActiveRecord::Base
  belongs_to :server
  belongs_to :guild
  belongs_to :race
  belongs_to :gender
  belongs_to :klass
  belongs_to :faction

  has_many :skill_levels
  has_many :professions, :class_name => "Profession", :source => :skill, :through => :skill_levels
  has_many :secondaries, :class_name => "Secondary", :source => :skill, :through => :skill_levels
  
  [Gender, Race, Klass, Faction].each do |c|
    c.find(:all).each do |g|
      named_scope g.name.downcase.gsub(" ","_").to_sym,
        { :conditions => {c.to_s.downcase.pluralize + ".name" => g.name}, 
          :include => c.to_s.downcase.to_sym }
    end
  end
  
  [Guild, Server].each do |c|
    named_scope c.name.downcase.to_sym,
      lambda { |n| 
        { :conditions => {c.to_s.downcase.pluralize + ".name" => n},
          :include => c.to_s.downcase.to_sym } }
  end
  
  named_scope :level, lambda { |l| { :conditions => ["level = ?", l] } }
  named_scope :min_level, lambda { |l| { :conditions => ["level > ?", l] } }
  named_scope :max_level, lambda { |l| { :conditions => ["level < ?", l] } }  
end
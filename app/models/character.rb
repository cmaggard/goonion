class Character < ActiveRecord::Base
  belongs_to :server
  belongs_to :guild
  belongs_to :race
  belongs_to :gender
  belongs_to :klass
  belongs_to :faction
  
  [Gender, Race, Klass, Faction].each do |c|
    c.find(:all).each do |g|
      named_scope g.name.downcase.gsub(" ","_").to_sym,
        { :conditions => {c.to_s.downcase.pluralize + ".name" => g.name}, 
          :include => c.to_s.downcase.to_sym }
    end
  end
  
  named_scope :level, lambda { |l| { :conditions => ["level = ?", l] } }
  named_scope :min_level, lambda { |l| { :conditions => ["level > ?", l] } }
  named_scope :max_level, lambda { |l| { :conditions => ["level < ?", l] } }  
end
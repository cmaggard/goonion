require 'rubygems'
require 'hpricot'
require 'open-uri'

module Goonion
  class NoSuchGuildError < Exception; end
  
  class Parser
    GUILD_ROSTER_URL = "http://armory.worldofwarcraft.com/guild-info.xml?brief=1&r=%s&n=%s"
    CHARACTER_SHEET_URL = "http://armory.worldofwarcraft.com/character-sheet.xml?r=%s&n=%s"
    CHARACTER_REP_URL = "http://armory.worldofwarcraft.com/character-reputation.xml?r=%s&n=%s"
    REQUEST_HASH = { "user-agent" =>
                      "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4" }
    
    attr_accessor :realm, :guild, :debug
    def initialize(realm = "Mal'Ganis", guild = "Goon Squad")
      self.realm = realm.gsub(" ","+")
      self.guild = guild.gsub(" ","+")
    end

    def parse!
      begin
        characters = retrieve_guild_names
        Rails.logger.debug "Guild names retrieved.  Count: #{characters.length}"
      rescue Exception => e
        raise e
      end
    end
    
    protected
    

    def retrieve_guild_names
      roster = Hpricot.XML(open(GUILD_ROSTER_URL % [realm, guild], REQUEST_HASH))
      begin
        memberlist = (roster % :page % :guildInfo % :guild % :members)
      
        (memberlist / :character).inject([]) do |k,v|
          k << v[:n]
        end
      rescue NoMethodError => e
        raise NoSuchGuildError
      end  
    end
  end
end
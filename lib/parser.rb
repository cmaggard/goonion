require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'uri'


class NoSuchGuildError < Exception; end
  
class Parser
  GUILD_ROSTER_URL = "http://www.wowarmory.com/guild-info.xml?brief=1&r=%s&n=%s"
  CHARACTER_SHEET_URL = "http://www.wowarmory.com/character-sheet.xml?r=%s&n=%s"
  CHARACTER_REP_URL = "http://www.wowarmory.com/character-reputation.xml?r=%s&n=%s"
  REQUEST_HASH = { "user-agent" =>
                    "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4",
                   "connection" => "close"}
  
  attr_accessor :realm_url, :guild_url, :realm, :guild, :realm_id, :guild_id, :guild_realm_set
  def initialize(realm = "Mal'Ganis", guild = "Goon Squad")
    self.realm = realm
    self.guild = guild
    self.guild_realm_set = false
  end

  def parse!
    begin
      characters = retrieve_guild_names
      Rails.logger.debug "Guild names retrieved.  Count: #{characters.length}"
      
      retrieve_realm_and_guild_ids
      
      characters.each do |c|
        parse_character(c)
        print "."
      end
    rescue Exception => e
      raise e
    end
  end
  
  protected
  
  def retrieve_realm_and_guild_ids
    self.realm_id = Server.find_or_create_by_name(realm)
    self.guild_id = self.realm_id.guilds.find_or_create_by_name(guild)
  end
  
  def parse_character(c)
    begin
      char = Server.find_by_name(realm_id.name).characters.find_or_create_by_name(c)
      
      unless char.created_at == char.updated_at
        return if char.updated_at > 1.day.ago
      end
      
      xml = Hpricot.XML(open(URI.escape(CHARACTER_SHEET_URL % [realm, c]), REQUEST_HASH))

      char.guild = self.guild_id
      char.server = self.realm_id
      
      character = (xml % :page % :characterInfo % :character)
      char.gender = Gender.find_by_name(character[:gender])
      char.race = Race.find_by_name(character[:race])
      char.klass = Klass.find_by_name(character[:class])
      char.level = character[:level]
      char.faction = Faction.find_by_name(character[:faction])
      
      # Can't get guild faction from guild page; if Guild does not have faction set, 
      unless guild_realm_set
        char.guild.update_attribute(:faction, char.faction) 
        guild_realm_set = false
      end
      char.save
      # Increase to 2.0 or 3.0 if seeing more errors
      sleep 1.0
      
    rescue OpenURI::HTTPError => e
      print "E"
      sleep 5.0
      retry
    rescue Timeout::Error => e
      print "T"
      sleep 5.0
      retry
    end
  end

  def retrieve_guild_names
    roster = Hpricot.XML(open(URI.escape(GUILD_ROSTER_URL % [realm, guild]), REQUEST_HASH))
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
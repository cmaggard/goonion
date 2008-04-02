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
  
  attr_accessor :realm_url, :guild_url, :realm, :guild, :realm_id, :guild_id
  def initialize(realm = "Mal'Ganis", guild = "Goon Squad")
    self.realm = realm
    self.guild = guild
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
    self.realm_id = Server.find_or_create_by_name(self.realm)
    self.guild_id = self.realm_id.guilds.find_or_create_by_name(self.guild)
  end
  
  def parse_character(c)
    begin
      char = Character.find_or_create_by_name(c)
      
      return if char.updated_at < 1.day.ago
      
      puts URI.escape(CHARACTER_SHEET_URL % [realm, c])
      xml = Hpricot.XML(open(URI.escape(CHARACTER_SHEET_URL % [realm, c]), REQUEST_HASH))

      char.guild = self.guild_id
      char.server = self.realm_id
      
      character = (xml % :page % :characterInfo % :character)
      char.gender = Gender.find_by_name(character[:gender])
      char.race = Race.find_by_name(character[:race])
      char.klass = Klass.find_by_name(character[:class])
      
      char.save
      
    rescue OpenURI::HTTPError => e
      print "HTTP Error."
      sleep 1.0
      retry
    rescue Timeout::Error => e
      print "Timeout"
      sleep 1.0
      retry
    rescue Exception => e
      raise e
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
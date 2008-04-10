require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'uri'


class NoSuchGuildError < Exception; end

class InactiveCharacterError < Exception; end
  
class Parser
  BASE_URL = "http://www.wowarmory.com/"
  URL = { :guild => "#{BASE_URL}guild-info.xml?brief=1&r=%s&n=%s",
          :character => "#{BASE_URL}character-sheet.xml?r=%s&n=%s",
          :reputation => "#{BASE_URL}character-reputation.xml?r=%s&n=%s",
          :skills => "#{BASE_URL}character-skills.xml?r=%s&n=%s" }
  REQUEST_HASH = { "user-agent" =>
                    "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4",
                   "connection" => "close"}
  
  def self.parse_guild(server = "Mal'Ganis", guild = "Goon Squad")!
    begin
      characters = retrieve_guild_members(server, guild)
      Rails.logger.debug "Guild members retrieved.  Count: #{characters.length}"
    
      characters.each do |c|
        parse_character(server, c, guild)
      end
        
      # Can't get guild faction from guild page; if Guild does not have faction set, 
      g = Server.find_by_name(server).guilds.find_by_name(guild)
      if g.faction = nil
        faction = g.characters.find(:first).faction
        g.update_attribute(:faction, faction)
      end
    rescue Exception => e
      raise e
    end
  end
  
  def self.parse_character(server_name, character_name, guild_name = nil)
    begin
      char = Server.find_or_create_by_name(server_name).characters.find_or_create_by_name(character_name)
    
      unless char.created_at == char.updated_at
        return if char.updated_at > 1.day.ago
      end
    
      xml = Hpricot.XML(open(URI.escape(URL[:skills] % [server_name, character_name]), REQUEST_HASH))

      char.server, char.guild = retrieve_server_and_guild_ids(server_name, guild_name)

      characterInfo = (xml % :page % :characterInfo)
      character = (characterInfo % :character)
      char.gender = Gender.find_by_name(character[:gender])
      char.race = Race.find_by_name(character[:race])
      char.klass = Klass.find_by_name(character[:class])
      char.level = character[:level]
      char.faction = Faction.find_by_name(character[:faction])


      ############################################################
      # Factor this into own method once parsing skills page
      # professions = (characterInfo % :characterTab % professions)
      # 
      # (professions / :skill).each do |p|
      # 
      # end
      ############################################################

      char.save
      # Increase to 2.0 or 3.0 if seeing more errors
      sleep 2.0
    
    rescue OpenURI::HTTPError => e
      sleep 5.0
      retry
    rescue Timeout::Error => e
      sleep 5.0
      retry
    rescue InactiveCharacterError => e
      # TODO: Set character.inactive to true before saving.
      char.save
      sleep 2.0
    end
  end

  def self.retrieve_guild_members(server, guild)
    roster = Hpricot.XML(open(URI.escape(URL[:guild] % [server, guild]), REQUEST_HASH))
    begin
      memberlist = (roster % :page % :guildInfo % :guild % :members)
  
      (memberlist / :character).inject([]) do |k,v|
        k << v[:n]
      end
    rescue NoMethodError => e
      raise NoSuchGuildError
    end  
  end

  protected 

  def self.retrieve_server_and_guild_ids(server, guild)
    server_id = Server.find_or_create_by_name(server)
    guild_id = server_id.guilds.find_or_create_by_name(guild)
    return server_id, guild_id
  end
end
require 'rubygems'
require 'hpricot'

module Goonion
  class Parser
    attr_accessor :realm, :guild
    def initialize(realm = "Mal'Ganis", guild = "Goon Squad")
      self.realm = realm
      self.guild = guild
    end
  end
end
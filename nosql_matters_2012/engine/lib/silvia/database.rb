module Silvia
  class Database

    def self.start
      Neo4j::Config.default_file='config/config.yml'
      Neo4j.start
    end

    def self.shutdown
      Neo4j.shutdown
    end

  end
end

require 'silvia/database'
require 'silvia/model'
require 'silvia/algorithms'

module Silvia

  def self.config
    @pacer = Pacer.neo4j(Neo4j.db.graph)
  end

  def self.pacer
    @pacer
  end

  class Node

    def self.create(clazz, props={})
      Neo4j::Transaction.run do
        clazz.new props
      end
    end

    def self.load(id)
      Neo4j::Node.load(id)
    end

    def self.find(clazz, query)
      clazz.find(query).to_a
    end

    def self.genres
      ::Genre.all.map do |genre|
        { :id => genre.neo_id, :genre => genre[:genre] }
      end
    end

  end

  class Relationship
    def self.create(clazz, source, target, props={})
      Neo4j::Transaction.run do
        clazz.new(clazz.to_sym, source, target, props)
      end
    end
  end
end

require 'silvia/init'


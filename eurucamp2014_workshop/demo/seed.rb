#!/usr/bin/env ruby

require 'rubygems'
require 'neo4j-wrapper'

Neo4j::Transaction.run do
  a = Neo4j::Node.new :name => 'A'
  b = Neo4j::Node.new :name => 'B'
  c = Neo4j::Node.new :name => 'C'
  d = Neo4j::Node.new :name => 'D'
  e = Neo4j::Node.new :name => 'E'
  f = Neo4j::Node.new :name => 'F'
  g = Neo4j::Node.new :name => 'G'
  Neo4j::Relationship.new(:friends, a, b)[:since] = 2008
  Neo4j::Relationship.new(:friends, a, c)[:since] = 2005
  Neo4j::Relationship.new(:friends, a, d)[:since] = 2003
  Neo4j::Relationship.new(:friends, c, b)[:since] = 2004
  Neo4j::Relationship.new(:friends, b, d)[:since] = 2001
  Neo4j::Relationship.new(:friends, b, e)[:since] = 2010
  Neo4j::Relationship.new(:friends, e, f)[:since] = 1998
  Neo4j::Relationship.new(:friends, e, g)[:since] = 2010

  Neo4j::Relationship.new(:recommend, a, d)
  Neo4j::Relationship.new(:recommend, a, c)
  Neo4j::Relationship.new(:recommend, c, g)
end

# Class objects

class Person
  include Neo4j::NodeMixin
  property :name,   :index => :exact
  property :wheels, :index => :exact
  property :age,    :index => :exact
  rule(:old) { age > 10 }
  rule :all
end

Neo4j::Transaction.run do
  Person.new :name => "asd", :wheels => 8, :age => 5
  Person.new :name => "andreas", :wheels => 2, :age => 43
  Person.new :name => "purbon", :age => 32
end

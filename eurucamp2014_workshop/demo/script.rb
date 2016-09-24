#!/usr/bin/env ruby


# Node.new

Neo4j::Node.new :name => 'foo', :age => 23, :hungry => false, 4 => 3.14

node = Neo4j::Node.new
node[:name]   = 'foo'
node[:age]    = 23
node[:hungry] = false
node[4] = 3.14

# Relationship.new

start_node = Neo4j::Node.new
end_node   = Neo4j::Node.new

Neo4j::Relationship.new(:friends, start_node, end_node)

start_node.outgoing(:friends) << end_node
start_node.friends << end_node

# Transaction.new

Neo4j::Transaction.new do
  node = Neo4j::Node.new
end

# Simple traversal

a.outgoing(:recommend).incomming(:friends).depth(:all).each do |node|
  puts node[:name]
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

Person.find('name: andreas').first

Person.find(:name => 'andreas').or(:wheels => 8).count

# Cypher

query_string = "START a=node(0) RETURN a"
Neo4j._query(query_string)

query_string = "START n=node(1) MATCH n-[:friends]-> x RETURN x"
Neo4j._query(query_string)

# resource consumption using cypher....

query_string = "START n=node(1) MATCH n-[:recommend]-> x RETURN x"
recommends  = Neo4j._query(query_string).to_a


#Neo4j on rails

rails new my_snn -m http://andreasronge.github.com/neo4j/rails.rb -O

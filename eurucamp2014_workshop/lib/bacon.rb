require 'neo4j-wrapper'
require 'neo4j-core'

module Bacon
  class PersonIndex
    extend Neo4j::Core::Index::ClassMethods
    include Neo4j::Core::Index

    node_indexer do
      index_names :exact => 'Person', :fulltext => 'Person'
    end
  end
end


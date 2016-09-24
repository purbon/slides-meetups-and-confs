class Station 
  include Neo4j::NodeMixin
  property :uid,  :index => :exact
  property :name, :index => :exact
  property :line, :index => :exact
end

class Connection
  include Neo4j::RelationshipMixin
  property :time
end

class Transfer
  include Neo4j::RelationshipMixin
  property :time
end

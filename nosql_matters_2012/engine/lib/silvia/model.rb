class Movie
  include Neo4j::NodeMixin
  property :movie_id, :title, :year
  index    :movie_id, :title
  rule(:all)
end

class User
  include Neo4j::NodeMixin
  property :user_id
  index    :user_id
  rule(:all)
end

class Genre
  include Neo4j::NodeMixin
  index    :genre
  rule :all
end

class Like
  include Neo4j::RelationshipMixin
  property :rate, :timestamp
end

class HasTag
  include Neo4j::RelationshipMixin
  property :tag, :timestamp
  index :tag
end

class HasGenre
  include Neo4j::RelationshipMixin
end

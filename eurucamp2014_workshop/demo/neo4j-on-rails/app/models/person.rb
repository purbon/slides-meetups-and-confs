class Person < Neo4j::Rails::Model

  property :name,  :type => String, :index => :exact, :unique => true
  property :email, :type => String
  property :age,   :type => Fixnum

  has_n(:friends).to(Person)
  has_n(:child).to(Person)

  validates             :name,  :uniqueness => true
  validates_presence_of :email

end

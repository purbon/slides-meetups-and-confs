module Import
  class Rating
    def initialize(inserter)
      @inserter =  inserter
    end


    def perform(file)
      file = File.new(file, "r")
      file.each_line("\n") do |row|
        columns = row.split("::")
        user    = addUser(columns[0])
        movie   = @inserter.index_get('movie_id', columns[1], :exact, ::Movie).first
        @inserter.create_rel(:likes, user, movie, properties(columns), Like)
      end
      file.close()
    end

    private

    #UserID::MovieID::Rating::Timestamp
    def properties(columns)
      { 'rate' => columns[2], 'timestamp' => columns[3] }
    end
    
    def addUser(user_id) 
      @inserter.index_flush(User)
      element = @inserter.index_get('user_id', user_id, :exact, User)
      return element.first if element and element.size > 0
      @inserter.create_node({'user_id' => user_id}, User)
    end



  end
end

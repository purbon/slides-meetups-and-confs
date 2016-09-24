module Import
  class Tag < Rating

    def perform(file)
      file = File.new(file, "r")
      file.each_line("\n") do |row|
        columns = row.split("::")
        user    = addUser(columns[0])
        movie   = @inserter.index_get('movie_id', columns[1], :exact, ::Movie).first
        @inserter.create_rel(:hasTags, user, movie, properties(columns), HasTag)
      end
      file.close()
    end

    private

    #UserID::MovieID::Tag::Timestamp
    def properties(columns)
      { 'tag' => columns[2], 'timestamp' => columns[3] }
    end


  end
end

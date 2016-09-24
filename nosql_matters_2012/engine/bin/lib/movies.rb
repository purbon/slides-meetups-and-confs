module Import

  class Movie

    def initialize(inserter)
      @inserter = inserter
    end

    def perform(file)
      file = File.new(file, "rb")
      file.each_line("\n") do |row|
        columns = row.split("::")
        props   = properties(columns)
        movie   = @inserter.create_node(props, ::Movie)
        addGenres(movie, columns[2].split('|'))
      end
      file.close()
    end

    private

    def properties(columns)
       {
          'movie_id' => columns[0],
          'title'    => columns[1]
       }
    end

    def addGenres(movie, genres)
      genres.each do |genre|
        genre.strip!
        next if genre.empty?
        genre = addGenre(genre)
        @inserter.create_rel(:hasGenres, movie, genre, {}, HasGenre)
      end
    end

    def addGenre(genre)
      @inserter.index_flush(Genre)
      element = @inserter.index_get('genre', genre, :exact, Genre)
      return element.first if element and element.size > 0
      @inserter.create_node({'genre' => genre}, Genre)
    end

  end
end

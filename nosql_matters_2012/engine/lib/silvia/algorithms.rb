require 'helpers/helpers'

module Silvia
  class Algorithms

    include Helpers

    def self.network(genres)
      genre   = Silvia.pacer.vertex genres.first.neo_id
      commons = most_frequent_genres(genre)
      genre.in(:hasGenres).map do |movie|
        genres = movie.out(:hasGenres).map { |genre| genre.getId }.to_a
        next unless validate_presence(commons, genres)
        {
          :title  => movie[:title],
          :genres => movie.out(:hasGenres).map { |genre| genre[:genre] }
        }
      end.to_a.compact
    end


    def self.discovery(user, page=1, per_page=25, limit=50000)
      user = Silvia.pacer.vertex user
      # Movies the given user likes, important to notice
      # the filter included, we take the movies with a more
      # big rate.
      traversal = user.out_e(:likes).filter do |e|
        e["rate"].to_f > 3.5
      end.in_v
      movies = user.out(:likes)
      # Get the users who liked the same movies our
      # given user like. Also with the same co-rating
      # filter included.
      traversal = traversal.in_e(:likes).filter do |e|
        e["rate"].to_f > 3.5
      end.out_v.except(user).uniq
      # Get movies liked but out related, "similar" users.
      # This movies are filtered in order to exclude the 
      # ones previously liked by the root user.
      traversal = traversal.out(:likes).except(movies).limit(limit)
      params = {:page => page, :per_page => per_page}

      paginate traversal.group_count{ |m| m.properties["title"] }.sort_by { |k| -k[1] }, params
    end

    # Look for movies recommended under the case that people
    # rated movies with a similiar rate.
    def self.similar(user, page=1, per_page=25, limit=50000)
      user = Silvia.pacer.vertex user
    
      # Find movies like by the analysed user. We only select
      # movies with a high rate, in our case more than 3.5
      traversal = user.out_e(:likes).filter do |e|
        e["rate"].to_f > 3.5
      end.as(:rates).in_v
    
      # save movies for later filtering.
      movies = user.out(:likes)
      
      # Select users who rate the movies we like on similar base 
      traversal = traversal.in_e(:likes).filter do |e|
        (e["rate"].to_f - e.vars[:rates]["rate"].to_f) == 0.5
      end.out_v.except(user).uniq
  
      # From now on we select movies like by the selected users, but
      # exclude the ones the analyzed user already rate.
      traversal = traversal.out(:likes).except(movies).limit(limit)
      params = {:page => page, :per_page => per_page}

      paginate traversal.group_count{ |m| m.properties["title"] }.sort_by { |k| -k[1] }, params
    end


    def self.tag_base_recommendation(user)
      user = Silvia.pacer.vertex user
      traversal = user.out_e(:likes).filter do |e|
        e["rate"].to_f > 3.5
      end.in_v
      relevant_tags = tfidf(traversal, 2).map{ |tag| tag[0] }
      traversal     = traversal.lookahead do |m|
                          m.in_e(:hasTags).filter{ |e| relevant_tags.include?(e[:tag]) } 
                      end
    end

    private


    def self.tfidf(movies, limit=10)
      tags        = movies.in_e(:hasTags).map{ |e| e["tag"] }
      tags_count  = tags.count.to_f
      total_docs  = Movie.all.count
      appears_in  = {}
      rank = tags.group_count.map do |e|
        tag  = e[0].gsub(/[' '|\:|\||\(|\)|\[|\]|\!|\"|\+]/) { |t| "\\#{t}" }
        appears_in[tag] ||= HasTag.find("tag: #{tag}").count.to_f
        idf = Math.log(total_docs / appears_in[tag] )
        e[1] = (e[1]/tags_count) * idf
        e
      end
      rank.sort_by{ |e| -e[1]}.first(limit)
    end

    def self.most_frequent_genres(genre, size=2)
      traversal = genre.in(:hasGenres).out(:hasGenres)
      traversal = traversal.most_frequent(0...size)
      traversal.map { |genre| genre.getId }.to_a
    end

    def self.validate_presence(a, b)
      a.map { |e| b.include?(e) }.include?(true)
    end

    def paginate_params(params = {})
      params ||= {}
      page = (params[:page] || params['page'] || 1).to_i
      per_page = (params[:per_page] || params['per_page'] || 0).to_i

      first = (page-1) * per_page
      last  = first + per_page -1

      [first, last]
    end

    #
    #  Takes an array and a hash and slices the hash to the section
    #  requested by params[:page] and params[:per_page]
    #
    def paginate(collection, params = {})
      first, last = paginate_params(params)
      collection[first..last]
    end

  end
end

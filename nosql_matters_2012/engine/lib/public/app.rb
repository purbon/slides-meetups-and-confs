require 'silvia/silvia'

class App < Sinatra::Application

  get '/' do
    erb :index
  end


  get '/network/:genre' do |genre|
    genres = Genre.find("genre: #{genre}")
    halt 404 if genres.empty?
    respond_with Silvia::Algorithms.network(genres)
  end

  # 77316
  get '/users/:id/discovery' do |user|
    discovery = Silvia::Algorithms.discovery(user)
    respond_with discovery
  end

  get '/users/:id/similar' do |user|
    discovery = Silvia::Algorithms.similar(user)
    respond_with discovery
  end

  get '/genres' do
    Silvia::Node.genres.to_json
  end

  at_exit do
    Silvia::Database.shutdown
  end

  private

  def respond_with(response, options={})
    status options[:status] || 200
    response.to_json
  end

end

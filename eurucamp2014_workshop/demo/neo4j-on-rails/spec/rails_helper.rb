require 'neo4j'

Neo4j::Config[:storage_path] = 'db/neo4j-test'

RSpec.configure do |config|

  config.before(:suite) do
    Neo4j.start
  end
  config.after(:suite) do
    Neo4j.shutdown
    FileUtils.rm_rf(Neo4j::Config[:storage_path])
  end

end

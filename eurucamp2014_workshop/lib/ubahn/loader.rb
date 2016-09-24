require 'csv'

module UBahn

  class Loader

    def create(lines_file, transfers_file)
      add_lines_from     lines_file
      add_transfers_from transfers_file
    end

    def add_transfers_from(transfers)
      CSV.foreach(transfers, :headers => :first_row) do |row|
        sources = Station.find("uid: #{row[0]}").to_a
        targets = Station.find("uid: #{row[1]}").to_a
        sources.each do |source|
          targets.each do |target|
            add_transfer(source, target, {type: row[2], time: row[3]})
          end
        end
      end
    end

    def add_lines_from(lines)
      line  = ""
      stops = []
      CSV.foreach(lines, :headers => :first_row) do |row|
        if (!line.empty? && row[2] != line && !stops.empty?)
          i=1
          while(i<stops.count)
            add_way(stops[i-1], stops[i])
            i += 1
          end
          stops = []
        end
        stops << add_stop(row)
        line = row[2]
      end
    end

    private

    def add_stop(data)
      Neo4j::Transaction.run do
        props        = { uid: data[0], name: data[1], line: data[2] }
        props[:time] = data[3] if (data.count > 3)
        Station.new(props)
      end
    end

    def add_way(from, to, props={})
      props[:time] = to.props['time'] if to.props['time']
      Neo4j::Transaction.run do
        Connection.new(:connection, from, to, props)
        to.remove_property('time')   if to.props['time']
        from.remove_property('time') if from.props['time']
      end
    end

    def add_transfer(from, to, props={})
      Neo4j::Transaction.run do
        Transfer.new(:transfer, from, to, props)
      end
    end
  end
end

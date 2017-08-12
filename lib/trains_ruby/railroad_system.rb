module TrainsRuby
  class RailroadSystem
    attr_reader :stations

    NoSuchRouteError = Class.new(StandardError)

    def initialize
      @stations = {}
    end

    def add_railroad(origin, destination, distance)

      @stations[origin] = Station.new(origin) unless @stations[origin]
      @stations[origin].add_railroad_to(destination, distance)
    end

    def get_route_distance(stop1, stop2, *stops)
      sum = 0

      stops.unshift(stop2)
      .unshift(stop1)
      .each_cons(2) do |s1, s2|
        raise NoSuchRouteError unless @stations[s1] && @stations[s1].has_railroad_to?(s2)
        sum += @stations[s1].get_distance_from(s2)
      end

      sum
    end

    def count_routes(origin, destination, options = {})
      return 0 unless @stations[origin]
      v = with_constraint(options)
      count_routes_recurr(destination, origin, {origin => true}, 0, 0, 0, &v)
    end

    private

    def count_routes_recurr(destination, current_station, visited, stops_count, current_distance, routes_count, &block)

      @stations[current_station].neighbours.to_a
      .reject { |next_station, next_distance|
        if block_given?
          yield(next_distance, current_distance)
        else
          false
        end
      }
      .each do |next_station, next_distance|
        if next_station == destination
          current_distance += next_distance
          stops_count += 1
          routes_count += 1
        elsif !visited.key?(next_station) && @stations.key?(next_station)
          routes_count +=
            count_routes_recurr(destination, next_station, visited.merge({next_station => true}), stops_count + 1, current_distance + next_distance, 0, &block)
        end
      end

      return routes_count
    end

    def with_constraint(options)
      constraint_type = options[:constraint_type]
      constraint_value = options[:constraint_value]

      case constraint_type
      when :max_distance
        return lambda{|next_distance, current_distance| constraint_value && constraint_value < next_distance + current_distance  }
      else
        nil
      end
    end

  end
end

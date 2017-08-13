module TrainsRuby
  module RouteCountQuery
    ConstraintError = Class.new(StandardError)

    def count_routes(origin, destination, constraint_type, constraint_value)
      raise NoSuchStationError, "invalid origin/destination" unless stations.key?(origin) && stations.key?(destination)

      to_destination = constrainted_reducer(destination, constraint_type, constraint_value)
      count_routes_from(origin, &to_destination)
    end

    private

    def count_routes_from(origin)
      routes = []
      queue = []

      queue << {station: origin, stops: 0, distance: 0, route:[origin]}

      while !queue.empty?
        current = queue.shift

        routes, constraint_exceeded = yield(routes, current)

        if !constraint_exceeded
          queue += stations[current[:station]].neighbours.map do |next_station, next_distance|
            {station: next_station,
             stops: current[:stops] + 1,
             distance: current[:distance] + next_distance,
             route: current[:route] + [next_station]}
          end
        end
      end
      # p routes
      routes.size
    end

    def constrainted_reducer(destination, constraint_type, constraint_value)
      check_constraints(constraint_type, constraint_value)

      constraint_exceeded = false

      case constraint_type
      when :max_distance
        lambda do |routes, current|
          constraint_exceeded = current[:distance] >= constraint_value
          if !constraint_exceeded && current[:station] == destination && current[:route].size > 1
            routes << current[:route]
          end
          return routes, constraint_exceeded
        end
      when :max_stops
        lambda do |routes, current|
          constraint_exceeded = current[:stops] > constraint_value
          if !constraint_exceeded && current[:station] == destination && current[:route].size > 1
            routes << current[:route]
          end
          return routes, constraint_exceeded
        end
      when :exact_stops
        lambda do |routes, current|
          constraint_exceeded = current[:stops] >= constraint_value
          if current[:stops] == constraint_value && current[:station] == destination && current[:route].size > 1
            routes << current[:route]
          end
          return routes, constraint_exceeded
        end
      end
    end

    def check_constraints(constraint_type, constraint_value)
      unless [:max_distance, :max_stops, :exact_stops].include?(constraint_type)
        raise ConstraintError, "Provided constraint type (#{constraint_type}) not in supported constraints"
      end
      unless constraint_value.is_a?(Integer) && constraint_value.to_i >= 0
        raise ConstraintError, "Provided constraint value (#{constraint_value}) is not a positive integer"
      end
    end

  end
end

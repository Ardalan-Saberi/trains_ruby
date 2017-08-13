module TrainsRuby
  class RailroadSystem
    attr_reader :stations

    NoSuchRouteError = Class.new(StandardError)
    ConstraintError = Class.new(StandardError)

    INFINITY = Float::INFINITY

    def initialize
      @stations = {}
    end

    def add_railroad(origin, destination, distance)

      @stations[origin] = Station.new(origin) unless @stations[origin]
      @stations[destination] = Station.new(destination) unless @stations[destination]
      @stations[origin].add_railroad_to(destination, distance)
    end

    def get_route_distance(stop1, stop2, *stops)
      totatl_distance = 0

      stops.unshift(stop2)
      .unshift(stop1)
      .each_cons(2) do |s1, s2|
        raise NoSuchRouteError unless @stations[s1] && @stations[s1].has_railroad_to?(s2)
        totatl_distance += @stations[s1].get_distance_from(s2)
      end

      totatl_distance
    end

    def count_routes(origin, destination, constraint_type, constraint_value)
      raise NoSuchRouteError unless @stations[origin] && @stations[destination]

      to_destination = constrainted_reducer(destination, constraint_type, constraint_value)

      count_routes_from(origin, &to_destination)
    end

    def get_shortest_route(origin, destination)
      raise NoSuchRouteError unless @stations[origin] && @stations[destination]

      min_distance_to, previous_station, unvisited = prepare_values(origin)

      while !unvisited.empty?
        nearest_station, min_distance = get_nearest_unvisited(origin, min_distance_to, unvisited)

        return min_distance if nearest_station == destination && min_distance != INFINITY

        unvisited.delete(nearest_station)

        @stations[nearest_station].neighbours.each do |neighbour, neighbour_distance|
          new_distance = (min_distance == INFINITY ? 0 : min_distance) + neighbour_distance

          if new_distance < min_distance_to[neighbour]
            min_distance_to[neighbour] = new_distance
            previous_station[neighbour] = nearest_station
          end
        end
      end

      if origin == destination &&  min_cycle_distance = min_distance_to
        .reject {|station_name, min_distance| station_name == destination}
        .reject {|station_name, min_distance| min_distance == INFINITY}
        .reject {|station_name, min_distance| !@stations[station_name].get_distance_from(destination)}
        .map {|station_name, min_distance| @stations[station_name].get_distance_from(destination) + min_distance}
        .min

        return min_cycle_distance
      end

      raise NoSuchRouteError
    end

    private

    def prepare_values(origin)
      min_distance_to = {}
      previous_station = {}
      unvisited = {}

      @stations.each_key do |station_name|
        min_distance_to[station_name] = INFINITY
        previous_station[station_name] = nil
        unvisited[station_name] = true
      end

      return min_distance_to, previous_station, unvisited
    end

    def get_nearest_unvisited(origin, min_distance_to, unvisited)
      nearest_station, min_distance = unvisited.keys
      .map {|station_name| [station_name, min_distance_to[station_name]] }
      .sort_by {|station_name, min_distance| min_distance}
      .first

      nearest_station = origin if min_distance == INFINITY && unvisited[origin]
      return nearest_station, min_distance
    end


    def count_routes_from(origin)
      routes = []
      queue = []

      queue << {station: origin, stops: 0, distance: 0, route:[origin]}

      while !queue.empty?
        current = queue.shift

        routes, constraint_exceeded = yield(routes, current)

        if !constraint_exceeded
          queue += @stations[current[:station]].neighbours.map do |next_station, next_distance|
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
      raise ConstraintError unless [:max_distance, :max_stops, :exact_stops].include?(constraint_type) && constraint_value.is_a?(Integer) && constraint_value.to_i >= 0

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
  end
end

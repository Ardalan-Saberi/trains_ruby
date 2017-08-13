module TrainsRuby
  module ShortestRouteQuery
    INFINITY = Float::INFINITY

    def get_shortest_route(origin, destination)
      raise NoSuchRouteError unless stations[origin] && stations[destination]

      min_distance_to, previous_station, unvisited = prepare_values(origin)

      while !unvisited.empty?
        nearest_station, min_distance = get_nearest_unvisited(origin, min_distance_to, unvisited)

        return min_distance if nearest_station == destination && min_distance != INFINITY

        unvisited.delete(nearest_station)

        stations[nearest_station].neighbours.each do |neighbour, neighbour_distance|
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
        .reject {|station_name, min_distance| !stations[station_name].neighbours[destination]}
        .map {|station_name, min_distance| stations[station_name].neighbours[destination] + min_distance}
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

      stations.each_key do |station_name|
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

  end
end

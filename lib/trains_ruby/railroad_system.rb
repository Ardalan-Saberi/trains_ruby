module TrainsRuby
  class RailroadSystem
    attr_reader :stations

    NoSuchRouteError = Class.new(StandardError)
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

    def count_routes(origin, destination, options = {})
      return 0 unless @stations[origin]
      count_routes_recurr(destination, origin, {origin => true}, 0, 0, 0, &with_constraint(options))
    end

    def get_shortest_route(origin, destination)
      raise NoSuchRouteError unless @stations[origin] && @stations[destination]

      min_distance_to, previous_station, unvisited = prepare_values(origin)

      while !unvisited.empty? do
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

      def count_routes_recurr(destination, current_station, visited, stops_count, current_distance, routes_count, &block)

        @stations[current_station].neighbours.to_a
        .map {|next_station, next_distance| [next_station, next_distance, next_station == destination]}
        .reject { |next_station, next_distance, is_next_destination|
          if block_given?
            yield(next_distance, current_distance, stops_count, is_next_destination)
          else
            false
          end
        }
        .each do |next_station, next_distance, is_next_destination|
          if is_next_destination
            # current_distance += next_distance
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
          return lambda{|next_distance, current_distance, stops_count, is_next_destination|
          constraint_value && next_distance + current_distance > constraint_value }
        when :max_stops
          return lambda{|next_distance, current_distance, stops_count, is_next_destination|
          constraint_value && stops_count >= constraint_value }
        when :exact_stops
          return lambda{|next_distance, current_distance, stops_count, is_next_destination|
          constraint_value && ((stops_count < constraint_value - 1 && is_next_destination) || (stops_count == constraint_value -1 && !is_next_destination) || (stops_count >= constraint_value))}
        else
          nil
        end
      end

    end
  end

module TrainsRuby
  module RailroadQuery
    NoSuchRouteError = Class.new(StandardError)

    module_function

    def get_route_distance(railroad_system, stop1, stop2, *stops)
      sum = 0

      stops.unshift(stop2)
      .unshift(stop1)
      .each_cons(2) do |s|

        raise NoSuchRouteError unless railroad_system.stations[s[0]] && railroad_system.stations[s[0]].has_railroad_to?(s[1])
        sum += railroad_system.stations[s[0]].get_distance_from(s[1])
      end

      sum
    end


  end
end

module TrainsRuby
  module RouteDistanceQuery

    def get_route_distance(stop1, stop2, *stops)
      totatl_distance = 0

      stops.unshift(stop2)
      .unshift(stop1)
      .each_cons(2) do |s1, s2|
        raise NoSuchRouteError unless stations[s1] && stations[s1].neighbours[s2]
        totatl_distance += stations[s1].neighbours[s2]
      end

      totatl_distance
    end
  end
end

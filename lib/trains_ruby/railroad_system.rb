
module TrainsRuby

  NoSuchRouteError = Class.new(StandardError)
  NoSuchStationError = Class.new(StandardError)

  class RailroadSystem
    include TrainsRuby::RouteCountQuery
    include TrainsRuby::RouteDistanceQuery
    include TrainsRuby::ShortestRouteQuery

    attr_reader :stations

    def initialize
      @stations = {}
    end

    def add_railroad(origin, destination, distance)

      @stations[origin] = Station.new(origin) unless @stations[origin]
      @stations[destination] = Station.new(destination) unless @stations[destination]
      @stations[origin].add_railroad_to(destination, distance)
    end
  end
end

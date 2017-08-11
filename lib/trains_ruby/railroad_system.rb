module TrainsRuby
  class RailroadSystem
    attr_reader :stations

    def add_railroad(origin_station_name, destination_station_name, distance)

      @stations[origin_station_name] = Station.new(origin_station_name) unless @stations[origin_station_name]
      @stations[origin_station_name].add_railroad_to(destination_station_name, distance)
    end

    def initialize
      @stations = {}
    end
  end
end

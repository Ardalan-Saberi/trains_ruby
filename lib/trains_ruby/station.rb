module TrainsRuby
  class Station
    attr_reader :name, :neighbours

    def initialize(name)
      @name = name
      @neighbours = {}
    end

    def add_railroad_to (station_name, distance)
      @neighbours[station_name] = distance
    end

    def has_railroad_to? station_name
      @neighbours.key?(station_name)
    end

    def get_distance_from station_name
      @neighbours[station_name]
    end

    def ==(other)
      @name == other.name
    end

    def eql?(other)
      self == other
    end

    def hash
      name.hash
    end
  end

  private_constant :Station
end

require 'spec_helper'

describe q = TrainsRuby::RailroadQuery do
  before(:all) do
    @empty_rs = TrainsRuby::RailroadSystem.new

    @single_road_rs = TrainsRuby::RailroadSystem.new
    @single_road_rs.add_railroad("A", "B", 5)

    @three_stations_rs = TrainsRuby::RailroadSystem.new
    @three_stations_rs.add_railroad("A", "B", 5)
    @three_stations_rs.add_railroad("B", "C", 4)
    @three_stations_rs.add_railroad("C", "A", 3)
  end

  describe "#get_route_distance" do

    it "should raise NoSuchRoadError if empty railroad system" do
      expect {q.get_route_distance(@empty_rs, "A", "B")}
      .to raise_error(q::NoSuchRouteError)
    end

    it "should raise NoSuchRoadError if the route does not exist" do
      expect {q.get_route_distance(@single_road_rs, "B", "A")}
      .to raise_error(q::NoSuchRouteError)
    end

    it "should return the lenght of a single railroad when given a single hop route" do
      expect(q.get_route_distance(@single_road_rs, "A", "B"))
      .to eql 5
    end


    it "should return the correct sum of distances of all railroads along the route" do
      expect(q.get_route_distance(@three_stations_rs, "A", "B", "C", "A"))
      .to eql 12
    end
  end
end

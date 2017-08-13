require 'spec_helper'

describe TrainsRuby::ShortestRouteQuery do
  include_context "shared railroad doubles"
  before(:each) do
    @empty_rs, @single_road_rs, @small_city_rs = double_railroads(TrainsRuby::ShortestRouteQuery)
  end

  describe "#get_shortest_route" do

    it "raise NoSuchRoute when given empty railroad system" do
      expect {@empty_rs.get_shortest_route("no_station1", "no_station2")}.to raise_error(TrainsRuby::NoSuchRouteError)
    end

    it "raise NoSuchRouteError when either of stations doesn't exist in railroad system" do
      expect {@single_road_rs.get_shortest_route("no_station", "A")}.to raise_error(TrainsRuby::NoSuchRouteError)
      expect {@single_road_rs.get_shortest_route("A", "no_station")}.to raise_error(TrainsRuby::NoSuchRouteError)
    end

    it "should return the length of the railroad in a single railroad system" do
      expect(@single_road_rs.get_shortest_route("A", "B")).to eql 5
    end

    it "should raise NoSychRouteError when no routes between origin and destination" do
      expect {@single_road_rs.get_shortest_route("B", "A")}.to raise_error(TrainsRuby::NoSuchRouteError)
    end

    it "should find shortest open routes when more than one way is possible" do
      expect(@small_city_rs.get_shortest_route("A", "C")).to eql 8
    end

    it "should find shortest closed routes when more than one way is possible" do
      expect(@small_city_rs.get_shortest_route("A", "A")).to eql 9
      expect(@small_city_rs.get_shortest_route("B", "B")).to eql 12
      expect(@small_city_rs.get_shortest_route("C", "C")).to eql 11
      expect(@small_city_rs.get_shortest_route("D", "D")).to eql 9

    end
  end
end

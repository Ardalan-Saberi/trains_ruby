require 'spec_helper'

describe R = TrainsRuby::RailroadSystem do
  before(:all) do
    @empty_rs = R.new

    @single_road_rs = R.new
    @single_road_rs.add_railroad("A", "B", 5)

    @small_city_rs = R.new
    @small_city_rs.add_railroad("A", "B", 5)
    @small_city_rs.add_railroad("B", "C", 4)
    @small_city_rs.add_railroad("C", "A", 3)
    @small_city_rs.add_railroad("A", "C", 14)
    @small_city_rs.add_railroad("A", "D", 6)
    @small_city_rs.add_railroad("D", "A", 3)
    @small_city_rs.add_railroad("D", "C", 2)

  end
  describe "#get_route_distance" do

    it "should raise NoSuchRoadError if empty railroad system" do
      expect {@empty_rs.get_route_distance("A", "B")}.to raise_error(R::NoSuchRouteError)
    end

    it "should raise NoSuchRoadError if the route does not exist" do
      expect {@single_road_rs.get_route_distance("B", "A")}.to raise_error(R::NoSuchRouteError)
    end

    it "should return the lenght of a single railroad when given a single hop route" do
      expect(@single_road_rs.get_route_distance("A", "B")).to eql 5
    end

    it "should return the correct sum of distances of all railroads along the route" do
      expect( @small_city_rs.get_route_distance("A", "B", "C", "A")).to eql 12
    end
  end

  describe "#count_routes" do

    it "should raise ConstraintError given invalid or nil constraint_type" do
      expect{@single_road_rs.count_routes("A", "B", "no_constraint", 0)}.to raise_error(R::ConstraintError)
      expect{@single_road_rs.count_routes("A", "B", nil, 0)}.to raise_error(R::ConstraintError)
    end
    it "should raise ConstraintError given not-integer, negaitive or nil constraint_value" do
      expect{@single_road_rs.count_routes("A", "B", :exact_stops, Object.new)}.to raise_error(R::ConstraintError)
      expect{@single_road_rs.count_routes("A", "B", :max_distance, -3)}.to raise_error(R::ConstraintError)
      expect{@single_road_rs.count_routes("A", "B", :max_stops,  nil)}.to raise_error(R::ConstraintError)
    end

    it "should return zero if origin or destination doesn't exist" do
      expect{@single_road_rs.count_routes("A", "no_station", :max_stops, 0)}.to raise_error(R::NoSuchRouteError)
    end
    it "should return zero if origin or destination doesn't exist" do
      expect{@single_road_rs.count_routes("no_station", "A", :max_distance, 0)}.to raise_error(R::NoSuchRouteError)
    end


    it "should count simple routes between origin and destination with maximum distance constraint" do
      expect(@small_city_rs.count_routes("A", "C", :max_distance, 9)).to eql(1)
    end
    it "should count complex (multi-visit) routes between origin and destination with maximum distance constraint" do
      expect(@small_city_rs.count_routes("A", "C", :max_distance, 18)).to eql(4)
    end
    it "should count closed routes between origin and destination with maximum distance limit" do
      expect(@small_city_rs.count_routes("D", "D", :max_distance, 12)).to eql(2)
    end


    it "should count simple routes between origin and destination with maximum 0 stops" do
      expect(@small_city_rs.count_routes("A", "C", :max_stops, 0)).to eql(0)
    end
    it "should count simple routes between origin and destination with maximum stops limit" do
      expect(@small_city_rs.count_routes("A", "C", :max_stops, 1)).to eql(1)
      expect(@small_city_rs.count_routes("A", "C", :max_stops, 2)).to eql(3)
    end
    it "should count complex (multi-visit) routes between origin and destination with maximum stops limit" do
      expect(@small_city_rs.count_routes("A", "C", :max_stops, 5)).to eql(19)
    end
    it "should count closed routes between origin and destination with maximum stops limit" do
      expect(@small_city_rs.count_routes("A", "A", :max_stops, 4)).to eql(8)
    end

    it "should count simple routes between origin and destination with exactly 0 stops constraint" do
      expect(@small_city_rs.count_routes("A", "C", :exact_stops, 0)).to eql(0)
    end
    it "should count simple routes between origin and destination with exact stops constraint" do
      expect(@small_city_rs.count_routes("A", "C", :exact_stops, 0)).to eql(0)
      expect(@small_city_rs.count_routes("A", "C", :exact_stops, 2)).to eql(2)
    end
    it "should count complex (multi-visit) routes between origin and destination with exact stops constraint" do
      expect(@small_city_rs.count_routes("A", "C", :exact_stops, 3)).to eql(2)
      expect(@small_city_rs.count_routes("A", "C", :exact_stops, 4)).to eql(6)
    end
    it "should count closed routes between origin and destination with exact stops constraint" do
      expect(@small_city_rs.count_routes("B", "B", :exact_stops, 6)).to eql(2)
    end
  end

  describe "#get_shortest_route" do

    it "raise NoSuchRoute when given empty railroad system" do
      expect {@empty_rs.get_shortest_route("no_station1", "no_station2")}.to raise_error(R::NoSuchRouteError)
    end

    it "raise NoSuchRouteError when either of stations doesn't exist in railroad system" do
      expect {@single_road_rs.get_shortest_route("no_station", "A")}.to raise_error(R::NoSuchRouteError)
      expect {@single_road_rs.get_shortest_route("A", "no_station")}.to raise_error(R::NoSuchRouteError)
    end

    it "should return the length of the railroad in a single railroad system" do
      expect(@single_road_rs.get_shortest_route("A", "B")).to eql 5
    end

    it "should raise NoSychRouteError when no routes between origin and destination" do
      expect {@single_road_rs.get_shortest_route("B", "A")}.to raise_error(R::NoSuchRouteError)
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

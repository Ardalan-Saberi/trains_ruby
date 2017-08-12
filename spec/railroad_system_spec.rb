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

    @disjoint_rs = R.new
    @disjoint_rs.add_railroad("A", "B", 5)
    @disjoint_rs.add_railroad("D", "C", 11)

    @sample_rs = R.new
    @sample_rs.add_railroad("A", "B", 5)
    @sample_rs.add_railroad("B", "C", 4)
    @sample_rs.add_railroad("C", "D", 8)
    @sample_rs.add_railroad("D", "C", 8)
    @sample_rs.add_railroad("D", "E", 6)
    @sample_rs.add_railroad("A", "D", 5)
    @sample_rs.add_railroad("C", "E", 2)
    @sample_rs.add_railroad("E", "B", 3)
    @sample_rs.add_railroad("A", "E", 7)
  end

  describe "#get_route_distance" do

    it "should raise NoSuchRoadError if empty railroad system" do
      expect {@empty_rs.get_route_distance("A", "B")}.to raise_error(R::NoSuchRouteError)
    end

    it "should raise NoSuchRoadError if the route does not exist" do
      expect {@single_road_rs.get_route_distance("B", "A")}.to raise_error(R::NoSuchRouteError)
    end

    it "should return the lenght of a single railroad when given a single hop route" do
      expect(@single_road_rs.get_route_distance( "A", "B")).to eql 5
    end

    it "should return the correct sum of distances of all railroads along the route" do
      expect( @small_city_rs.get_route_distance("A", "B", "C", "A")).to eql 12
    end
  end

  describe "#count_routes" do

    it "should return zero if origin doesn't exist" do
      expect(@single_road_rs.count_routes("no_station", "A")).to eql(0)
    end

    it "should return zero when there's no route between origin and destination" do
      expect(@disjoint_rs.count_routes("A", "D")).to eql(0)
      expect(@disjoint_rs.count_routes("B", "B")).to eql(0)
    end

    it "should count all routes between origin and destination when no options provided" do
      expect(@small_city_rs.count_routes("A", "C")).to eql(3)
      expect(@small_city_rs.count_routes("D", "A")).to eql(2)
    end

    it "should count all circular routes between a node back to itself" do
      expect(@small_city_rs.count_routes("A", "A")).to eql(4)
    end

    it "should count routes between origin and destination with maximum distance limit" do
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :max_distance, constraint_value: 7})).to eql(0)
      expect(@small_city_rs.count_routes("A", "C",  {constraint_type: :max_distance, constraint_value: 8})).to eql(1)
      expect(@small_city_rs.count_routes("A", "C",  {constraint_type: :max_distance, constraint_value: 9})).to eql(2)
    end

    it "should count routes between origin and destination with maximum stops limit" do
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :max_stops, constraint_value: 0})).to eql(0)
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :max_stops, constraint_value: 1})).to eql(1)
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :max_stops, constraint_value: 2})).to eql(3)
    end

    it "should count routes between origin and destination with exact stops limit" do
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :exact_stops, constraint_value: 0})).to eql(0)
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :exact_stops, constraint_value: 1})).to eql(1)
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :exact_stops, constraint_value: 2})).to eql(2)
      expect(@small_city_rs.count_routes("A", "C", {constraint_type: :exact_stops, constraint_value: 3})).to eql(0)
    end
  end
end

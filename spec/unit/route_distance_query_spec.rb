require 'spec_helper'

describe TrainsRuby::RouteDistanceQuery do
  include_context "shared railroad doubles"

  before(:each) do
    @empty_rs, @single_road_rs, @small_city_rs, @disjoint_rs = double_railroads(TrainsRuby::RouteDistanceQuery)
  end

  describe "#get_route_distance" do

    it "should raise NoSuchRoadError if empty railroad system" do
      expect {@empty_rs.get_route_distance("A", "B")}.to raise_error(TrainsRuby::NoSuchRouteError)
    end

    it "should raise NoSuchRoadError if the route does not exist" do
      expect {@single_road_rs.get_route_distance("B", "A")}.to raise_error(TrainsRuby::NoSuchRouteError)
    end

    it "should return the lenght of a single railroad when given a single hop route" do
      expect(@single_road_rs.get_route_distance("A", "B")).to eql 5
    end

    it "should return the correct sum of distances of all railroads along the route" do
      expect( @small_city_rs.get_route_distance("A", "B", "C", "A")).to eql 12
    end
  end

end

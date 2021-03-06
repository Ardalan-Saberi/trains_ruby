require 'spec_helper'

describe R = TrainsRuby::RouteCountQuery do
  include_context "shared railroad doubles"

  before(:each) do
    @empty_rs, @single_road_rs, @small_city_rs, @disjoint_rs = double_railroads(TrainsRuby::RouteCountQuery)
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
      expect{@single_road_rs.count_routes("A", "no_station", :max_stops, 0)}.to raise_error(TrainsRuby::NoSuchStationError)
    end
    it "should return zero if origin or destination doesn't exist" do
      expect{@single_road_rs.count_routes("no_station", "A", :max_distance, 0)}.to raise_error(TrainsRuby::NoSuchStationError)
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
end

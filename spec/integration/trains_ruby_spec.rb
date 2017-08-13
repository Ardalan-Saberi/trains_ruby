require "spec_helper"

describe "Sample Input E2E test" do

  before(:each) do
    @rs = TrainsRuby::RailroadHelper.create_railroad_system_from_string("AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7")
  end

  #1
  it "should return 9 as distance of route A-B-C9" do
    expect(@rs.get_route_distance("A", "B", "C")).to eql 9
  end

  #2
  it "should return 5 as distance of route A-D" do
    expect(@rs.get_route_distance("A", "D")).to eql 5
  end

  #3
  it "should return 13 as distance of route A-D-C" do
    expect(@rs.get_route_distance("A", "D", "C")).to eql 13
  end

  #4
  it "should return 22 as distance of route A-E-B-C-D" do
    expect(@rs.get_route_distance("A", "E", "B", "C", "D")).to eql 22
  end

  #5
  it "should raise NoSuchRouteError when asked for distance of route A-E-D" do
    expect{@rs.get_route_distance("A", "E", "D")}.to raise_error(TrainsRuby::NoSuchRouteError)
  end

  #6
  it "should return 2 as number of trips from C to C with maximum of 3 stops" do
    expect(@rs.count_routes("C", "C", :max_stops, 3)).to eql 2
  end

  #7
  it "should return 3 as number of trips from A to C with exactly 4 stops" do
    expect(@rs.count_routes("A", "C", :exact_stops, 4)).to eql 3
  end

  #8
  it "should return 9 as shortest route between A and C" do
    expect(@rs.get_shortest_route("A", "C")).to eql 9
  end

  #9
  it "should return 9 as shortest route between B and B" do
    expect(@rs.get_shortest_route("B", "B")).to eql 9
  end

  #10
  it "should return 7 as number of trips from C to C with maximum distance of 30" do
    expect(@rs.count_routes("C", "C", :max_distance, 30)).to eql 7
  end


end

RSpec.shared_context "shared railroad doubles", :shared_context => :metadata do

  def double_railroads(mixin)

    empty_rs = double("RailroadSystem", :stations => {})
    empty_rs.extend(mixin)

    station_a = double("Station", :name => "A", :neighbours => {"B" => 5})
    station_b = double("Station", :name => "B", :neighbours => {})

    single_road_rs = double("RailroadSystem", :stations => {station_a.name => station_a,
                                                            station_b.name => station_b})
    single_road_rs.extend(mixin)



    station_a = double("Station", :name => "A", :neighbours => {"B" => 5, "C"=>5})
    station_b = double("Station", :name => "B", :neighbours => {"C" => 1, "A" => 8})
    station_c = double("Station", :name => "C", :neighbours => {"B" => 5, "A" => 12})
    station_d = double("Station", :name => "D", :neighbours => {"E" => 2})
    station_e = double("Station", :name => "E", :neighbours => {"D" => 5})
    disjoint_rs = double("RailroadSystem", :stations => {station_a.name => station_a,
                                                         station_b.name => station_b,
                                                         station_c.name => station_c,
                                                         station_d.name => station_d,
                                                         station_e.name => station_e})
    disjoint_rs.extend(mixin)

    station_a = double("Station", :name => "A", :neighbours => {"B" => 5, "C" => 14, "D" => 6})
    station_b = double("Station", :name => "B", :neighbours => {"C" => 4})
    station_c = double("Station", :name => "C", :neighbours => {"A" => 3})
    station_d = double("Station", :name => "D", :neighbours => {"A" => 3, "C" => 2})

    small_city_rs = double("RailroadSystem", :stations => {station_a.name => station_a,
                                                           station_b.name => station_b,
                                                           station_c.name => station_c,
                                                           station_d.name => station_d})
    small_city_rs.extend(mixin)

    return empty_rs, single_road_rs, small_city_rs, disjoint_rs
  end
end

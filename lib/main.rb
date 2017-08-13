load "trains_ruby/version.rb"
load "trains_ruby/station.rb"
load "trains_ruby/railroad_system.rb"
load "trains_ruby/railroad_helper.rb"

rs = TrainsRuby::RailroadHelper.create_railroad_system_from_string("AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7")

p "Output #1: #{rs.get_route_distance('A', 'B', 'C')}"
p "Output #2: #{rs.get_route_distance('A', 'D')}"
p "Output #3: #{rs.get_route_distance('A', 'D', 'C')}"
p "Output #4: #{rs.get_route_distance('A', 'E', 'B', 'C', 'D')}"

begin
  rs.get_route_distance('A', 'E', 'D')
rescue TrainsRuby::RailroadSystem::NoSuchRouteError
  p 'Output #5: NO SUCH ROUTE'
end

p "Output #6: #{rs.count_routes('C', 'C', :max_stops, 3)}"
p "Output #7: #{rs.count_routes('A', 'C', :exact_stops, 4)}"
p "Output #8: #{rs.get_shortest_route('A', 'C')}"
p "Output #9: #{rs.get_shortest_route('B', 'B')}"
p "Output #10: #{rs.count_routes('C', 'C', :max_distance, 30)}"

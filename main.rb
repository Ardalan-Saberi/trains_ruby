# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

DELIMITER_TOKEN = " "
CommandParsingError = StandardError.new

require "trains_ruby/version.rb"
require "trains_ruby/station"
require "trains_ruby/route_count_query"
require "trains_ruby/route_distance_query"
require "trains_ruby/shortest_route_query"
require "trains_ruby/railroad_helper"
require "trains_ruby/railroad_system"

begin
  rs = TrainsRuby::RailroadSystem.new

  puts "opening file #{ARGV[0]}"
  file = File.open(ARGV[0], "r")

rescue => err
  puts "exception opening file #{err}"
  file.close
end

line_number = 0

while (line= file.gets)
  puts "#{line}"
  line_output = ""

  args = line.split(DELIMITER_TOKEN)
  command = args.shift

  begin
    case command
    when "load"
      rs = TrainsRuby::RailroadHelper.create_railroad_system_from_array(*args)
      line_output = "RailroadSystem Created with #{rs.stations.size()} stations"

    when "get_route_distance"
      line_output = rs.get_route_distance(*args)

    when "get_shortest_route"
      line_output = rs.get_shortest_route(args[0], args[1])

    when "count_routes"
      line_output = rs.count_routes(args[0], args[1], args[2].to_sym, args[3].to_i).to_s

    else
      line_output = "undefined command"
    end

  rescue => err
    line_output = err.message
  ensure
    puts "=> #{line_output}"
  end
end

file.close

puts "done!"

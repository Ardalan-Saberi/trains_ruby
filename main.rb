lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trains_ruby.rb'

DELIMITER_TOKEN = " "
CommandParsingError = StandardError.new

begin
  rs = TrainsRuby::RailroadSystem.new

  input_file_name =  ARGV[0]
  puts "# reading instructions from file #{input_file_name}"

  input_file = File.open(input_file_name, "r")

rescue => err
  TLog.log.error "[#{input_file_name}]  #{err}"
  puts "# failed to open the #{input_file_name}"

else
  line_number = 0

  while (line= input_file.gets)
    puts "#{line}"
    line_number += 1
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
      TLog.log.error "[#{input_file_name}, line: #{line_number}] #{err}"
      line_output = err.message
    ensure
      puts "=> #{line_output}"
    end
  end

  ensure
    input_file.close if input_file
    puts "# done!"
  end

module TrainsRuby
  module RailroadHelper

    RailroadStringParseError = Class.new(StandardError)

    RAILROAD_ITEM_FROMAT = /(^|\W)(?<origin>[a-zA-Z])(?<destination>[a-zA-Z])(?<distance>\d+)(\W|$)/
    RAILROAD_ITEM_DELIMITER = ','

    module_function

    def create_railroad_system_from_string str
      create_railroad_system_from_array *str.split(RAILROAD_ITEM_DELIMITER)
    end

    def create_railroad_system_from_array *items
      result = RailroadSystem.new

      items.each do |item|
        unless m = item.match(RAILROAD_ITEM_FROMAT)
          raise RailroadStringParseError, "near ...#{item}..."
        end

        result.add_railroad(m["origin"], m["destination"], m["distance"].to_i)
      end

      result
    end
  end
end

require 'spec_helper'

describe h = TrainsRuby::RailroadHelper do
  describe "#create_railroad_system_from_string" do

    it "create an empty railroad system given an empty string" do
      rs = h.create_railroad_system_from_string("")

      expect(rs).not_to be_nil
      expect(rs.stations).to be_empty
    end

    it "creates a railroad system with one road" do
      rs = h.create_railroad_system_from_string("AB25")

      expect(rs.stations).to have_key "A"
      expect(rs.stations["A"].neighbours).to have_key "B"
      expect(rs.stations["A"].neighbours["B"]).to eql(25)
    end

    it "raises error when string cannot be parsed" do
      expect{ h.create_railroad_system_from_string("AB5, 4BB3")}.to raise_error(h::RailroadStringParseError)
    end


    it "creates a railroad system with multiple roads" do
      rs = h.create_railroad_system_from_string("AB5, BC22, CB3")

      expect(rs.stations).to have_key "A"
      expect(rs.stations).to have_key "B"
      expect(rs.stations).to have_key "C"
      expect(rs.stations["A"].neighbours).to have_key "B"
      expect(rs.stations["B"].neighbours).to have_key "C"
      expect(rs.stations["C"].neighbours).to have_key "B"
      expect(rs.stations["B"].neighbours).not_to have_key "A"
      expect(rs.stations["C"].neighbours).not_to have_key "C"
      expect(rs.stations["A"].neighbours["B"]).to eql(5)
      expect(rs.stations["B"].neighbours["C"]).to eql(22)
      expect(rs.stations["C"].neighbours["B"]).to eql(3)
    end
  end
end

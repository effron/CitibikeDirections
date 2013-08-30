require 'spec_helper'
require 'json'
require './lib/citi_bike_directions/path.rb'

describe Path do

  let(:path) { Path.new(JSON.parse(File.read("./spec/fixtures/path.json"))) }

  describe "#distance" do
    it "should return the path's distance" do
      path.distance.should == 3332
    end
  end

  describe "#duration" do
    it "should return duration" do
      path.duration.should == 946
    end
  end

  describe "#start_location" do
    it "should be a location object" do
      path.start_location.should be_kind_of(Location)
    end
  end


  describe "#end_location" do
    it "should be a location object" do
      path.end_location.should be_kind_of(Location)
    end
  end


end

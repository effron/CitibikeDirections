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

  describe "#steps" do
    it "should be an array" do
      path.steps.should be_kind_of(Array)
    end
    
    it "should be an array of step objects" do
      path.steps[0].should be_kind_of(Step)
    end
  end

  describe "#polyline" do
    it "should return an array" do
      path.polyline.should be_kind_of(Array)
    end
  end

end

require 'spec_helper'
require 'json'
require './lib/citi_bike_directions/step.rb'

describe Step do

  let(:step) { Step.new(JSON.parse(File.read("./spec/fixtures/path.json"))['steps'].first) }

  describe "#distance" do
    it "should return the path's distance" do
      step.distance.should == 16
    end
  end

  describe "#duration" do
    it "should return duration" do
      step.duration.should == 3
    end
  end

  describe "#start_location" do
    it "should return location object" do
      step.start_location.should be_kind_of(Location)
    end
  end

  describe "#end_location" do
    it "should return location object" do
      step.end_location.should be_kind_of(Location)
    end
  end

  describe "#html_instructions" do
    it "should return html instructions" do
      step.html_instructions.should == "Head <b>northwest</b> on <b>Murray Street</b> toward <b>Church St</b>"
    end
  end

  describe "#maneuver" do
    it "should return maneuver (nil for first)" do
      step.maneuver.should == nil
    end
  end

  describe "#polyline" do
    it "should return polyline" do
      step.polyline.should == "{{nwF`yubMM^"
    end
  end

  describe "#travel_mode" do
    it "should return travel mode" do
      step.travel_mode.should == "BICYCLING"
    end
  end

end

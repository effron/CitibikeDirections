require 'spec_helper'
require 'json'
require './lib/citi_bike_directions/location.rb'

describe Location do

  let(:location) { Location.new({ "address"=> "Honorable Barrington D Parker, New York, NY 10007, USA", 
                                 "location"=> { "lat"=> 40.7137379, "lng"=> -74.0086456 }}) }

  describe "#lat_lng" do
    it "should return the path's lat and lng" do
      location.lat_lng.should == [40.7137379, -74.0086456]
    end
  end

  describe "#lat" do
    it "should return lat" do
      location.lat.should == 40.7137379
    end
  end

  describe "#lng" do
    it "should return lng" do
      location.lng.should == -74.0086456
    end
  end

  describe "#address" do
    it "should return address" do
      location.address.should == "Honorable Barrington D Parker, New York, NY 10007, USA"
    end
  end



end

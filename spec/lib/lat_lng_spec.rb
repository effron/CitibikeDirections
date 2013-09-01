require 'spec_helper'
require 'json'
require './lib/citi_bike_directions/lat_lng.rb'

describe LatLng do

  let(:lat_lng) { LatLng.new({ "lat" => 40.7137379, "lng" => -74.0086456 }) }

  describe "#lat_lng" do
    it "should return the path's lat and lng" do
      lat_lng.lat_lng.should == [40.7137379, -74.0086456]
    end
  end

  describe "#lat" do
    it "should return lat" do
      lat_lng.lat.should == 40.7137379
    end
  end

  describe "#lng" do
    it "should return lng" do
      lat_lng.lng.should == -74.0086456
    end
  end


end

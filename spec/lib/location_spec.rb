require 'spec_helper'
require 'json'
require './lib/citi_bike_directions/location.rb'

describe Location do

  let(:location) { Location.new({ "address"=> "Honorable Barrington D Parker, New York, NY 10007, USA", 
                                 "location"=> { "lat"=> 40.7137379, "lng"=> -74.0086456 }}) }

  describe "#lat_lng" do
    it "should return a LatLng object" do
      location.lat_lng.should be_kind_of(LatLng)
    end
  end

  describe "#address" do
    it "should return address" do
      location.address.should == "Honorable Barrington D Parker, New York, NY 10007, USA"
    end
  end



end

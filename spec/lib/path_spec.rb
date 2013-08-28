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


end

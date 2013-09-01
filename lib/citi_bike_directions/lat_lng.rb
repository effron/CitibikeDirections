class LatLng
  
  attr_reader :lat, :lng
  
  def initialize(lat_lng)
    @lat = lat_lng["lat"]
    @lng = lat_lng["lng"]
  end
  
  def lat_lng
    [@lat, @lng]
  end
end
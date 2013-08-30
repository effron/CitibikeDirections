class Location
  attr_reader :address, :lat, :lng

  def initialize(location)
    @address = location["address"]
    @lat = location["location"]["lat"]
    @lng = location["location"]["lng"]
  end

  def lat_lng
    [@lat, @lng]
  end

end
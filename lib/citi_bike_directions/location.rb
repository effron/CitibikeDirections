class Location
  attr_reader :address, :lat_lng

  def initialize(location)
    @address = location["address"]
    @lat_lng = LatLng.new({ "lat" => location["location"]["lat"], 
                            "lng" => location["location"]["lng"] })
  end

end
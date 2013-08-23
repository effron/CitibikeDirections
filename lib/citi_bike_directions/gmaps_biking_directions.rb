module GmapsBikingDirections

  def get_biking_directions(coord1, coord2)
    #coordinates should be in '12.2345, 56,6789' format
    url = Addressable::URI.new(
        scheme: "http",
        host: "maps.googleapis.com",
        path: "maps/api/directions/json",
        query_values: {
            origin:       coord1,
            destination:  coord2,
            sensor:       false,
            mode:         "bicycling"
        }
      ).to_s

    result = JSON.parse(RestClient.get(url))
    

    result['routes'].first['legs']
  end


end
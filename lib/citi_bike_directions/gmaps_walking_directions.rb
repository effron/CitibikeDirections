module GmapsWalkingDirections

  def get_walking_directions_with_waypoints(coord1, waypoint1, waypoint2, coord2)
    #coordinates/waypoints should be in '12.2345, 56,6789' format
    #ex. '40.7136487, -74.0087126', '40.709329, -74.0131196', '40.6998433, -74.0072436', '40.7038704, -74.0138541'
    url = Addressable::URI.new(
        scheme: "http",
        host: "maps.googleapis.com",
        path: "maps/api/directions/json",
        query_values: {
            origin:       coord1,
            destination:  coord2,
            sensor:       false,
            mode:         "walking",
            waypoints:    "#{waypoint1}|#{waypoint2}"
        }
      ).to_s

    result = JSON.parse(RestClient.get(url))

    result['routes'].first['legs']
  end

end
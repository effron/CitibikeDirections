require 'citibikenyc'
require 'json'
require 'addressable/uri'
require 'rest-client'

# Eventually should give combination walking/biking directions around NYC.
# Walk to nearest available citibike
# Bike to stations with available docks nearest to destination
# Walk from that station to destination

class CitiBike
  
  attr_reader :client, :stations, :avail_bike_stations, :avail_dock_stations
  
  def initialize(user_agent)
    @client = Citibikenyc.client(user_agent: user_agent, debug: true)
    @stations = @client.stations.results
  end
  
  def find_by_id(id)
    @stations.find { |station| station.id = id }
  end
  
  def find_avail_bike_stations(n = 5)
    stations.select { |station| station.availableBikes > n }
  end
  
  def find_avail_dock_stations(n = 5)
    stations.select{ |station| station.availableDocks > n }
  end
  
  def station_locations_with_ids(stations)
    stations.map { |station| [station.latitude, station.longitude, station.id]}
  end
  
  def find_nearest_avail_bike(coords)
    dests = find_nearest_avail_station_locations(coords) # pull out 5 nearest using lat-long calcuations
    params = build_dmatrix_params(dests, coords)
    url = build_dmatrix_url(params)
    p url
    results = JSON.parse(RestClient.get(url))
    seconds = parse_results_into_distance_array(results)
    
    mintime = 999999999
    destindex = -1
    seconds.each_with_index do |time, index|
      destindex = index if time < mintime
    end

    find_by_id(dests[destindex][2])
    
  end
  
  def parse_results_into_distance_array(results)
    results["rows"][0]["elements"].map do |element|
      element["distance"]["value"]
    end    
  end
  
  def distance(start,finish)
    x1, y1 = start
    x2, y2 = finish
    dx = x2 - x1
    dy = y2 - y1
    Math.sqrt(dx**2 + dy**2)
  end
  
  def find_nearest_avail_station_locations(coords, n = 5)
    locs = station_locations_with_ids(find_avail_bike_stations)
    locs.sort_by { |rack| distance(coords,rack[0..1]) }
    locs[0...n]
  end
  
  def build_dmatrix_url(qv_hash)
    Addressable::URI.new(
    scheme: "http",
    host: "www.google.com",
    path: "maps/api/distancematrix/json",
    query_values: qv_hash
    ).to_s
  end
  
  def build_dmatrix_params(dests, coords)    
    dest_str = dests.map { |lat, long, id| "#{lat},#{long}" }.join("|")
    p dest_str
    orig_str = coords.join(",")
    { destinations: dest_str, origins: orig_str, sensor: false, mode: "walking" }
    
  end
end
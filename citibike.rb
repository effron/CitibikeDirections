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
  
  
  def find_avail_bike_stations(n = 5)
    stations.select { |station| station.availableBikes > n }
  end
  
  def find_avail_dock_stations(n = 5)
    stations.select{ |station| station.availableDocks > n }
  end
  
  def station_locations(stations)
    stations.map { |station| [station.latitude, station.longitude]}
  end
  
  def find_nearest_avail_bike(coords)
    find_nearest_avail_station_locations(coords) # pull out 5 nearest using lat-long calcuations
    
    # then use maps API to see which is actually nearest for walking
    # this saves you from having to do 347 API calls
  end
  
  def distance(start,finish)
    x1, y1 = start
    x2, y2 = finish
    dx = x2 - x1
    dy = y2 - y1
    Math.sqrt(dx**2 + dy**2)
  end
  
  def find_nearest_avail_station_locations(coords, n = 5)
    locs = station_locations(find_avail_bike_stations)
    locs.sort_by { |rack| distance(coords,rack) }
    locs[0...n]
  end
  
end
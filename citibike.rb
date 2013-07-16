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
    # first pull out 3-10 nearest using lat-long calcuations
    # then use maps API to see which is actually nearest for walking
        # this saves you from having to do 347 API calls
  end
  
  
end
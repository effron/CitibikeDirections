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
  
  def initialize(user_agent, availability_tolerance = 5)
    @client = Citibikenyc.client(user_agent: user_agent, debug: true)
    @stations = @client.stations.results
    @avail_tol = availability_tolerance
  end
  
  def find_by_id(id)
    @stations.find { |station| station.id == id }
  end
  
  def find_avail_bike_stations(n = @avail_tol)
    stations.select { |station| station.availableBikes > n }
  end
  
  def find_avail_dock_stations(n = @avail_tol)
    stations.select{ |station| station.availableDocks > n }
  end
  
  def find_nearest_avail_bike(coords)
    find_nearest_avail(coords, :bike)
  end
  
  def find_nearest_avail_dock(coords)
    find_nearest_avail(coords, :dock)
  end
  
  private
  
    def station_locations_with_ids(stations)
      stations.map { |s| [s.latitude, s.longitude, s.id]}
    end
    
    def find_nearest_avail(coords, bike_or_dock)
      case bike_or_dock
      when :bike
        dests = find_nearest_avail_bike_locations(coords) 
      when :dock
        dests = find_nearest_avail_dock_locations(coords) 
      else
        raise "bike_or_dock has to be bike or dock symbol"
      end
    
      params = build_dmatrix_params(dests, coords)
      url = build_dmatrix_url(params)
      p url #debug
    
      results = JSON.parse(RestClient.get(url))
      distances = parse_results_into_distance_array(results)
    
      find_by_id(dests[distances.index(distances.min)][2])
    end
  
    def parse_results_into_distance_array(results)
      results["rows"][0]["elements"].map do |element|
        element["distance"]["value"]
      end
    end
  
    def find_nearest_avail_bike_locations(coords, n = @avail_tol)
      locs = station_locations_with_ids(find_avail_bike_stations)
      sort_locations_by_distance(coords, locs, n)
    end
  
    def find_nearest_avail_dock_locations(coords, n = @avail_tol)
      locs = station_locations_with_ids(find_avail_dock_stations)
      sort_locations_by_distance(coords, locs, n)
    end
  
    def sort_locations_by_distance(coords, locs, n)
      sorted_locs = locs.sort_by { |rack| distance(coords,rack[0..1]) }
      sorted_locs[0...n]
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
      p dest_str #debug
      orig_str = coords.join(",")
      { destinations: dest_str, 
        origins:      orig_str, 
        sensor:       false, 
        mode:         "walking" }    
    end  
  
    def distance(start,finish)
      x1, y1 = start
      x2, y2 = finish
      dx = x2 - x1
      dy = y2 - y1
      Math.sqrt(dx**2 + dy**2)
    end
  
end
require 'citibikenyc'
require 'json'
require 'addressable/uri'
require 'rest-client'
require 'geocoder'
require 'polylines'
require 'citi_bike_directions/helper_methods'
require 'citi_bike_directions/distance_matrix_helper'
require 'citi_bike_directions/gmaps_biking_directions'
require 'citi_bike_directions/gmaps_walking_directions'

class CitiBikeDirections
  include HelperMethods
  include DistanceMatrixHelper
  include GmapsBikingDirections
  include GmapsWalkingDirections
  
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

  def find_nearest_avail_bike(address)
    coords = address_to_lat_lng(address)
    find_nearest_avail(coords, :bike)
  end

  def find_nearest_avail_dock(address)
    coords = address_to_lat_lng(address)
    find_nearest_avail(coords, :dock)
  end

  def find_total_directions(start_address, finish_address)
    nearest_bike = find_nearest_avail_bike(start_address)
    nearest_dock = find_nearest_avail_dock(finish_address)

    walking_directions = get_walking_directions_with_waypoints(start_address, "#{nearest_bike['latitude']},#{nearest_bike['longitude']}", 
      "#{nearest_dock['latitude']},#{nearest_dock['longitude']}", finish_address)
    biking_directions = get_biking_directions("#{nearest_bike['latitude']},#{nearest_bike['longitude']}", 
      "#{nearest_dock['latitude']},#{nearest_dock['longitude']}")

    directions = [walking_directions[0]].concat(biking_directions) << (walking_directions[2])
    directions.to_json
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

    def distance(start,finish)
      dx, dy = finish[0] - start[0], finish[1] - start[1]

      Math.sqrt(dx**2 + dy**2)
    end

end


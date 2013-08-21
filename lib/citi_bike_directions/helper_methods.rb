module HelperMethods
  def address_to_lat_lng(address)
    result = Geocoder.search(address)
    lat = result.first.data['geometry']['location']['lat']
    lng = result.first.data['geometry']['location']['lng']

    [lat, lng]
  end
end
module DistanceMatrixHelper
  
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

end
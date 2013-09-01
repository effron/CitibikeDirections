class Step
  attr_reader :distance, :duration, :start_location, :end_location,
                :html_instructions, :maneuver, :polyline, :travel_mode

  def initialize(step)
    @distance = step['distance']['value']
    @duration = step['duration']['value']
    @start_location = Location.new({"location"=> step['start_location']})
    @end_location = Location.new({"location"=> step['end_location']})
    @html_instructions = step['html_instructions']
    @maneuver = step['maneuver']
    @polyline = decode_polyline(step['polyline']['points'])
    @travel_mode = step['travel_mode']
  end

  def decode_polyline(polyline)
    Polylines::Decoder.decode_polyline(polyline)
  end

end
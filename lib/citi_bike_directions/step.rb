class Step
  attr_reader :distance, :duration, :start_latitude, :start_longitude, :end_latitude, :end_longitude,
                :instructions, :maneuver, :polyline, :travel_mode

  def initialize(step)

    @distance = step['distance']['value']
    @duration = step['duration']['value']
    # @start_latitude = step['start_location']['latitude']
    # @start_longitude = step['start_location']['longitude']
    @start = Location.new({location: leg['start_location']})

    @end_latitude = step['end_location']['latitude']
    @end_longitude = step['end_location']['longitude']
    @instructions = step['html_instructions']
    @maneuver = step['maneuver']
    @polyline = step['polyline']['points']
    @travel_mode = step['travel_mode']

  end

end
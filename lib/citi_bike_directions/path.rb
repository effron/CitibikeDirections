class Path
  attr_reader :distance, :duration, :start_location, :end_location, :steps

  def initialize(leg)
    @distance = leg['distance']['value']
    @duration = leg['duration']['value']
    @start_location = Location.new({"address"=> leg['start_address'], "location"=> leg['start_location']})
    @end_location = Location.new({"address"=> leg['end_address'], "location"=> leg['end_location']})
    @steps = []

    leg['steps'].each do |step|
      @steps << Step.new(step)
    end
  end
  
  def polyline
    @steps.map { |step| step.polyline }.flatten(1)
  end
end

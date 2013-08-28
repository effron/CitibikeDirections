class Path
  attr_accessor :distance

  def initialize(leg)

    @distance = leg['distance']['value']

  end
end

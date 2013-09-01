Gem::Specification.new do |s|
  s.name = 'citi_bike_directions'
  s.version = '0.0.4'
  s.date = '2013-08-21'
  s.summary = 'Get citibike directions with Google maps!'
  s.description = 'Enter a start and end point, get full citibike directions to your destination'
  s.authors = ['Jin Park', 'Harris Effron']
  s.email = 'harris.effron@gmail.com'
  s.files = ['lib/citi_bike_directions.rb',
    'lib/citi_bike_directions/helper_methods.rb',
    'lib/citi_bike_directions/distance_matrix_helper.rb',
    'lib/citi_bike_directions/gmaps_biking_directions.rb',
    'lib/citi_bike_directions/gmaps_walking_directions.rb']
  s.homepage = 'http://rubygems.org/gems/citi_bike_directions'
  s.license = 'MIT'
  s.add_dependency 'citibikenyc'
  s.add_dependency 'json'
  s.add_dependency 'addressable'
  s.add_dependency 'rest-client'
  s.add_dependency 'geocoder'
  s.add_dependency 'polylines'
end
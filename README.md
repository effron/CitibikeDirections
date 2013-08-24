CitiBikeDirections
==================
Enter your start and end address, and get back step by step directions using CitiBike!

##Installation
`gem install citi_bike_directions`

##Usage:

    directions_finder = CitiBikeDirections.new('user_agent', availability_tolerance = 5)
    directions_finder.find_total_directions(start_address, finish_address)

This will return a 3 leg Google maps directions JSON, with the first leg being walking directions to the nearest CitiBike station with at least 5 (or whatever you put for `availability_tolerance`) available bikes, then biking directions to the CitiBike station nearest the destination with at leat 5 available docks, and walking directions from there to your destination.

##TODO:

Accept a maximum ride time (either 30 or 45 minutes), and break up biking legs if it exceeds that time.
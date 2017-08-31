# Neighborhood boundaries download:
# https://raw.githubusercontent.com/blackmad/neighborhoods/master/chicago.geojson

neighborhoods = Neighborhood.read("chicago-neighborhoods.geojson")

for {k, v} <- neighborhoods do
  IO.puts k
  IO.inspect v
end

pt = %Geo.Point{coordinates: {-87.632903, 41.853690}}
IO.puts Neighborhood.find_neighborhood(neighborhoods, pt)

pt = %Geo.Point{coordinates: {-87.646423, 41.844575}}
IO.puts Neighborhood.find_neighborhood(neighborhoods, pt)

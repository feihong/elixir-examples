# Neighborhood boundaries download:
# https://raw.githubusercontent.com/blackmad/neighborhoods/master/chicago.geojson

features = File.read!("chicago-neighborhoods.geojson")
  |> Poison.decode!
  |> (fn map -> map["features"] end).()

for feature <- features do
  IO.puts feature["properties"]["name"]
  geom = feature["geometry"] |> Geo.JSON.decode
  IO.inspect geom
end

# Neighborhood boundaries download:
# https://raw.githubusercontent.com/blackmad/neighborhoods/master/chicago.geojson

neighborhoods = File.read!("chicago-neighborhoods.geojson")
  |> Poison.decode!
  |> (fn map -> map["features"] end).()
  |> Enum.map(fn feature -> {
    feature["properties"]["name"],
    feature["geometry"] |> Geo.JSON.decode} end)
  |> Enum.into(%{})

for {k, v} <- neighborhoods do
  IO.puts k
  IO.inspect v
end

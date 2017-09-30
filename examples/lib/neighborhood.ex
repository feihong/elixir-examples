defmodule Neighborhood do
  @doc """
  Takes the path of a geojson file and returns a list of pairs of the format
  {neighborhood_name, boundary_geometry}.
  """
  def read(cache_name) do
    path = "cache/#{cache_name}.json"
    if File.exists?(path) do
      File.read!(path)
        |> Poison.decode!
        |> (fn map -> map["features"] end).()
        |> Enum.map(fn feature -> {
          feature["properties"]["name"],
          feature["geometry"] |> Geo.JSON.decode} end)
    else
      []
    end
  end

  def find_neighborhood(neighborhoods, point) do
    neighborhoods
      |> Enum.find(fn {_name, geom} -> Topo.contains?(geom, point) end)
      |> (fn result ->
            case result do
              {name, _geom} -> name
              _ -> nil
            end
          end).()
  end
end

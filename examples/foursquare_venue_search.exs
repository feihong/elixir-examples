# https://developer.foursquare.com/docs/venues/search

url = "https://api.foursquare.com/v2/venues/search"
cfg = Application.fetch_env!(:examples, FourSquare)
params = %{
  v: "20170827",
  m: "foursquare",
  client_id: cfg[:client_id],
  client_secret: cfg[:client_secret],
  ll: "41.854107,-87.632086",
  radius: 1600,
  query: "restaurant",
  intent: "browse",
  limit: 50,
}

venues = Download.fetch("foursquare__venues", url, params)["response"]["venues"]
for {venue, num} <- Enum.with_index(venues, 1) do
  IO.puts "#{num}. #{venue["name"]}"
  categories = venue["categories"] |> Enum.map(fn cat -> cat["shortName"] end)
  IO.puts "    " <> Enum.join(categories, ", ")
  IO.puts ""
end


IO.puts "Got #{length(venues)} venues"

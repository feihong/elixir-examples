# https://developer.foursquare.com/docs/venues/explore

url = "https://api.foursquare.com/v2/venues/explore"
cfg = Application.fetch_env!(:examples, FourSquare)
params = %{
  v: "20170827",
  m: "foursquare",
  client_id: cfg[:client_id],
  client_secret: cfg[:client_secret],
  ll: "41.854107,-87.632086",
  radius: 1600,
  section: "food",
  # query: "chinese"
  # novelty: "new",
  limit: 50,
}

groups = Download.fetch("foursquare__venues", url, params)["response"]["groups"]

# group_names = groups |> Enum.map(fn gr -> gr["name"] end)
# IO.puts "Groups: #{inspect group_names}"

items = List.first(groups)["items"]
for {item, num} <- Enum.with_index(items, 1) do
  # IO.inspect item
  venue = item["venue"]
  IO.puts "#{num}. #{venue["name"]}"
  categories = venue["categories"] |> Enum.map(fn cat -> cat["shortName"] end)
  IO.puts "    " <> Enum.join(categories, ", ")
  IO.puts "    " <> List.first(item["tips"])["canonicalUrl"]
  # IO.puts "    " <>
  IO.puts ""
end

IO.puts "Got #{length(items)} venues"

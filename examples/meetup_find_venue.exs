url = "https://api.meetup.com/find/venues"
params = %{
  key: Application.fetch_env!(:examples, Meetup)[:api_key],
  location: "Millenium Park",
  text:  "Millenium Park",
  longitude: "-87.62185999999997",
  latitude: "41.8831824",
  radius: "1"
}

venues = Download.fetch("meetup__venue", url, params)
for venue <- venues do
  IO.puts venue["name"]
end

IO.puts "Got #{length(venues)} venues"

# data = HTTPoison.get!(url, [], params: params)
#   |> (fn response -> response.body end).()
#   |> Poison.decode!

# IO.puts(data |> Poison.encode!(pretty: true))

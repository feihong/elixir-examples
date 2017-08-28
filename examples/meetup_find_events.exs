url = "https://api.meetup.com/find/events"
params = %{
  key: Application.fetch_env!(:examples, Meetup)[:api_key],
  lat: 41.852912,
  lon: -87.632059,
  radius: 1,
  # text:  "china",
}

events = Download.fetch("meetup__events", url, params)
for {evt, num} <- Enum.with_index(events, 1) do
  IO.puts "#{num}. #{evt["name"]}"
  IO.puts "    " <> evt["group"]["name"]
  if Map.has_key?(evt,  "venue") do
    IO.puts "    " <> evt["venue"]["name"]
  end
  dt = DateTime.from_unix!(evt["time"], :milliseconds)
  IO.puts "    " <> Timex.format!(dt, "{Mshort} {D}, {YYYY}")
  IO.puts ""
end

IO.puts "\nGot #{length(events)} events"

# data = HTTPoison.get!(url, [], params: params)
#   |> (fn response -> response.body end).()
#   |> Poison.decode!

# IO.puts(data |> Poison.encode!(pretty: true))

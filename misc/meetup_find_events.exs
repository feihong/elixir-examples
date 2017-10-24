url = "https://api.meetup.com/find/events"
params = %{
  key: Application.fetch_env!(:misc, Meetup)[:api_key],
  lat: 41.881204,
  lon: -87.627984,
  radius: 25,
  text:  "chinese",
}

ignore = [
  "chinese-11",
  "Chinese-Language-Excitement",
  "Free-Kung-Fu-Tai-Chi-Class",
]

events = Download.fetch("meetup__events", url, params)
  |> Enum.filter(fn evt -> evt["group"]["urlname"] not in ignore end)

for {evt, num} <- Enum.with_index(events, 1) do
  IO.puts "#{num}. #{evt["name"]}"
  IO.puts "    " <> evt["group"]["name"]
  if Map.has_key?(evt,  "venue") do
    IO.puts "    " <> evt["venue"]["name"]
  end
  dt = DateTime.from_unix!(evt["time"], :milliseconds)
  IO.puts "    " <> Timex.format!(dt, "{Mshort} {D}, {YYYY}")
  IO.puts "    " <> evt["link"]
  IO.puts ""
end

IO.puts "Got #{length(events)} events"

# data = HTTPoison.get!(url, [], params: params)
#   |> (fn response -> response.body end).()
#   |> Poison.decode!

# IO.puts(data |> Poison.encode!(pretty: true))

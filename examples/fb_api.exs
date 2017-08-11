access_token = File.read!("config.json")
  |> Poison.decode!
  |> (fn cfg -> cfg["access_token"] end).()

HTTPoison.start

data = HTTPoison.get!(
  "https://graph.facebook.com/v2.9/siskelfilmcenter/events",
  [],
  params: %{access_token: access_token})
  |> (fn response -> response.body end).()
  |> Poison.decode!

# IO.puts data

# Write the prettified JSON to file.
data
  |> Poison.encode!(pretty: true)
  |> (fn data -> File.write("response.json", data) end).()

events = data["data"]
for event <- events do
  IO.puts event["name"]
end
IO.puts "Wrote #{length(events)} items to response.json"

access_token = File.read!("config.json")
  |> Poison.decode!
  |> (fn cfg -> cfg["access_token"] end).()

HTTPoison.start

data = HTTPoison.get!(
  "https://graph.facebook.com/v2.9/siskelfilmcenter/events",
  [],
  params: %{access_token: access_token})
  |> (fn response -> response.body end).()

# Write the prettified JSON to file.
data
  |> Poison.decode!
  |> Poison.encode!(pretty: true)
  |> (fn data -> File.write("response.json", data) end).()

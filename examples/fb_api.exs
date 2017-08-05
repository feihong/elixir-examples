access_token = File.read!("config.json")
  |> Poison.decode!
  |> (fn cfg -> cfg["access_token"] end).()

HTTPoison.start
res = HTTPoison.get!(
  "https://graph.facebook.com/v2.9/siskelfilmcenter/events",
  [],
  params: %{access_token: access_token})

# IO.puts res.body
File.write("response.json", res.body)

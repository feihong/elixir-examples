
config = File.read!("config.json")
  |> Poison.decode!


defmodule Fetch do
  @access_token config["access_token"]

  def fetch(name) do
    cache_name = "facebook__#{name}"
    url = "https://graph.facebook.com/v2.9/#{name}/events/"
    params = %{access_token: @access_token,
               since: DateTime.utc_now |> DateTime.to_iso8601}

    Download.fetch(cache_name, url, params)["data"]
  end
end


pages = config["pages"]

events = pages
  |> Enum.map(fn name -> Fetch.fetch(name) end)
  |> List.flatten
  |> Enum.sort_by(fn event -> event["start_time"] end)

for event <- events do
  IO.puts event["name"]
  IO.puts event["start_time"]
  IO.puts "------------------------"
end

IO.puts "Fetched #{length(events)} events"

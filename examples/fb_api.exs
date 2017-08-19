config = File.read!("config.json")
  |> Poison.decode!

defmodule Fetch do
  @access_token config["access_token"]

  def fetch(name) do
    params = %{access_token: @access_token,
               since: DateTime.utc_now() |> DateTime.to_iso8601()}
    data = HTTPoison.get!(
      "https://graph.facebook.com/v2.9/#{name}/events/",
      [],
      params: params)
      |> (fn response -> response.body end).()
      |> Poison.decode!

    data
  end
end


pages = config["pages"]

data = Fetch.fetch(List.first pages)

# Write the prettified JSON to file.
data
  |> Poison.encode!(pretty: true)
  |> (fn data -> File.write("response.json", data) end).()

events = data["data"]
|> Enum.sort_by(fn x -> x["start_time"] end)

for event <- events do
  IO.puts "#{event["name"]}, #{event["start_time"]}"
end
IO.puts "\nWrote #{length(events)} items to response.json"

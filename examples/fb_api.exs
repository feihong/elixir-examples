config = File.read!("config.json")
  |> Poison.decode!

defmodule Fetch do
  @access_token config["access_token"]

  def fetch(name) do
    IO.puts name
    path = "cache_pages/facebook__#{name}.json"

    if File.exists?(path) do
      File.read!(path)
      |> Poison.decode!
      |> (fn data -> data["data"] end).()
    else
      params = %{access_token: @access_token,
                 since: DateTime.utc_now |> DateTime.to_iso8601}
      data = HTTPoison.get!(
        "https://graph.facebook.com/v2.9/#{name}/events/",
        [],
        params: params)
        |> (fn response -> response.body end).()
        |> Poison.decode!

      write_to_file(path, data)
      data["data"]
    end
  end

  def write_to_file(path, data) do
    data
      |> Poison.encode!(pretty: true)
      |> (fn text -> File.write(path, text) end).()
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

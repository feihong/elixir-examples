config = File.read!("config.json")
  |> Poison.decode!


defmodule Download do
  def fetch(cache_name, url, params) do
    path = "cache_pages/#{cache_name}.json"

    if File.exists?(path) do
      File.read!(path)
      |> Poison.decode!
    else
      data = HTTPoison.get!(url, [], params: params)
        |> (fn response -> response.body end).()
        |> Poison.decode!

      write_to_file(path, data)
      data
    end
  end

  defp file_is_recent?(path) do
    File.exists?(path)
  end

  defp write_to_file(path, data) do
    data
      |> Poison.encode!(pretty: true)
      |> (fn text -> File.write(path, text) end).()
  end
end

defmodule Fetch do
  @access_token config["access_token"]

  def fetch(name) do
    IO.puts name
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

require Logger


config = File.read!("config.json")
  |> Poison.decode!


defmodule Download do
  @hour 60 * 60

  def fetch(cache_name, url, params) do
    path = "cache_pages/#{cache_name}.json"

    if file_is_recent?(path) do
      Logger.info "Retrieving #{cache_name} from cache"
      File.read!(path)
      |> Poison.decode!
    else
      Logger.info "Downloading #{cache_name} from #{url}"
      data = HTTPoison.get!(url, [], params: params)
        |> (fn response -> response.body end).()
        |> Poison.decode!

      write_to_file(path, data)
      data
    end
  end


  # Returns true if the file at the given path exists and was created less than
  # 24 hours ago; false otherwise.
  defp file_is_recent?(path) do
    ctime = File.stat!(path, time: :posix).ctime |> DateTime.from_unix!
    File.exists?(path) and DateTime.diff(DateTime.utc_now(), ctime) < (24 * @hour)
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

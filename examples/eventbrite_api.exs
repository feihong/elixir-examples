defmodule EventBrite do
  @base_url "https://www.eventbriteapi.com/v3"
  @access_token Application.fetch_env!(:examples, EventBrite)[:access_token]

  def fetch_all() do
    url = "#{@base_url}/events/search/"
    params = %{
      token: @access_token,
      q: "china",
      "location.address": "Chicago, IL"
    }
    Download.fetch("eventbrite__china", url, params)["events"]
      |> Enum.map(&download_venue/1)
  end

  def download_venue(evt) do
    # IO.inspect evt
    venue_id = evt["venue_id"]
    url = "#{@base_url}/venues/#{venue_id}/"
    params = %{token: @access_token}
    venue = Download.fetch("eventbrite__venue__#{venue_id}", url, params)
    evt |> Map.put("venue", venue)
  end
end

for evt <- EventBrite.fetch_all() do
  IO.puts evt["name"]["text"]
  IO.puts evt["venue"]["name"]
  IO.puts evt["start"]["local"]
  IO.puts ""
end

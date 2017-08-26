defmodule EventBrite do
  @base_url "https://www.eventbriteapi.com/v3"
  @access_token Application.fetch_env!(:examples, EventBrite)[:access_token]

  def fetch_all() do
    url = "#{@base_url}/events/search/"
    params = %{
      token: @access_token,
      q: "chinese",
      "location.address": "Chicago, IL"
    }
    data = Download.fetch("eventbrite__chinese", url, params)
    events = data["events"]
      |> Enum.map(&download_venue/1)
    {data["pagination"], events}
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

{pagination, events} = EventBrite.fetch_all()
for evt <- events do
  IO.puts evt["name"]["text"]
  IO.puts evt["venue"]["name"]
  IO.puts evt["start"]["local"]
  IO.puts ""
end

%{"has_more_items" => has_more_items, "object_count" => event_count} = pagination
IO.puts "\nFound #{event_count} items"
IO.puts "Are there more items? #{has_more_items}"

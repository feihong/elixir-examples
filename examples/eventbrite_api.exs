defmodule EventBrite do
  @base_url "https://www.eventbriteapi.com/v3"
  @access_token Application.fetch_env!(:examples, EventBrite)[:access_token]
  @keywords Application.fetch_env!(:examples, :keywords)

  def fetch_all() do
    @keywords
      |> Enum.map(&fetch/1)
      |> List.flatten
      |> Enum.uniq_by(fn evt -> evt["id"] end)
      |> Enum.sort_by(&sort_mapper/1)
  end

  defp fetch(keyword) do
    url = "#{@base_url}/events/search/"
    params = %{
      token: @access_token,
      q: keyword,
      sort_by: "date",
      "location.address": "Chicago, IL"
    }
    data = Download.fetch("eventbrite__#{keyword}", url, params)
    events = data["events"]
      |> Enum.map(&download_venue/1)
  end

  defp download_venue(evt) do
    venue_id = evt["venue_id"]
    url = "#{@base_url}/venues/#{venue_id}/"
    params = %{token: @access_token}
    venue = Download.fetch("eventbrite__venue__#{venue_id}", url, params)
    evt |> Map.put("venue", venue)
  end

  defp sort_mapper(evt) do
    evt["start"]["local"]
  end
end

events = EventBrite.fetch_all()
for {evt, num} <- Enum.with_index(events, 1) do
  IO.puts "#{num}. #{evt["name"]["text"]}"
  IO.puts evt["venue"]["name"]
  IO.puts evt["start"]["local"]
  IO.puts ""
end

IO.puts "\nFound #{length(events)} items"

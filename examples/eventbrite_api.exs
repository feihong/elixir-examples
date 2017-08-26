defmodule EventBrite do
  @access_token Application.fetch_env!(:examples, EventBrite)[:access_token]

  def fetch_all() do
    url = "https://www.eventbriteapi.com/v3/events/search/"
    params = %{
      token: @access_token,
      q: "china",
      "location.address": "Chicago, IL"
    }
    Download.fetch("eventbrite__china", url, params)["events"]
  end
end

for event <- EventBrite.fetch_all() do
  IO.puts event["name"]["text"]
  IO.puts event["start"]["local"]
  IO.puts ""
end

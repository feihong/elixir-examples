url = "https://www.eventbriteapi.com/v3/events/search/"
token = Application.fetch_env!(:examples, EventBrite)[:access_token]
params = %{
  token: token,
  q: "china",
  "location.address": "Chicago, IL"
}
# IO.inspect params
events = Download.fetch("eventbrite__china", url, params)["events"]
for event <- events do
  IO.puts event["name"]["text"]
  IO.puts event["start"]["local"]
  IO.puts ""
end

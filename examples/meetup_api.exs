url = "https://api.meetup.com/find/venues"
params = %{
  key: Application.fetch_env!(:examples, Meetup)[:api_key],
  location: "Chicago, IL",
  text: "Whitney M. Young Magnet High School",
  zip: "60607"
}
Download.fetch("meetup__venue", url, params)

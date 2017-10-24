name = "AMC River East 21"

url = "https://api.meetup.com/find/venues"
params = %{
  key: Application.fetch_env!(:misc, Meetup)[:api_key],
  text: name,
  location: "322 E Illinois St, Chicago, IL 60611",
}

venues = Download.fetch("meetup__venue", url, params)
match_venues =
  venues
  |> Enum.filter(fn v -> v["name"] == name end)
  |> Enum.sort_by(fn v -> v["rating_count"] end, &>=/2)

# for venue <- match_venues do
#   IO.puts "# ratings: #{venue["rating_count"]}, rating: #{venue["rating"]}"
#   IO.puts venue["address_1"]
# end

venue = List.first(match_venues)
IO.puts "Most rated venue:"
IO.puts "Rating: #{venue["rating"]}"
IO.puts "Rating count: #{venue["rating_count"]}"
IO.puts "Address: #{venue["address_1"]}"

IO.puts "\nGot #{length(venues)} venues, #{length(match_venues)} that matched"

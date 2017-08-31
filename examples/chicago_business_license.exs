# Browse data:
# https://data.cityofchicago.org/Community-Economic-Development/Business-Licenses/r5kz-chrr/data
# API docs:
# https://dev.socrata.com/foundry/data.cityofchicago.org/xqx5-8hwx

url = "https://data.cityofchicago.org/resource/xqx5-8hwx.json"
app_token = Application.fetch_env!(:examples, BusinessLicense)[:app_token]
date = Timex.shift(Timex.today(), months: -3)
date_str = Timex.format!(date, "{YYYY}-{0M}-{0D}T00:00:00.000")
params = %{
  "$$app_token": app_token,
  license_description: "Retail Food Establishment",
  application_type: "ISSUE",
  license_status: "AAI",
  "$where": "license_start_date > '#{date_str}'"
}

neighborhoods = Neighborhood.read("chicago-neighborhoods.geojson")
find_hood = fn point ->
   Neighborhood.find_neighborhood(neighborhoods, point)
end

target_activities = [
  "Preparation of Food and Dining on Premise With Seating",
  "Sale of Food Prepared Onsite With Dining Area"
]
target_neighborhoods = [
  "Bridgeport",
  "Chinatown"
]

filter_fn = fn lic ->
  target_activities
    |> Enum.any?(fn activity ->
        String.contains?(lic["business_activity"], activity) end)
end

sort_map = fn lic ->
  num = if lic["neighborhood"] in target_neighborhoods, do: 0, else: 1
  {num, lic["start_date"]}
end

licenses = Download.fetch("business_licenses", url, params)
  |> Enum.filter(filter_fn)
  |> Enum.map(fn lic ->
      hood = if Map.has_key?(lic, "longitude") do
        point = {
          lic["longitude"] |> String.to_float,
          lic["latitude"] |> String.to_float
        }
        find_hood.(point)
      else
        "N/A"
      end
      Map.put(lic, "neighborhood", hood)
    end)
  |> Enum.sort_by(sort_map)

for {lic, num} <- Enum.with_index(licenses, 1) do
  IO.puts "#{num}. #{lic["doing_business_as_name"]}"
  IO.puts "    Neighborhood: " <> lic["neighborhood"]
  # IO.puts "    Ward: " <> lic["ward"]
  # IO.puts "    Activity: " <> lic["business_activity"]
  IO.puts "    " <> lic["license_start_date"]
  IO.puts "    " <> lic["address"]
end

readable_date_str = Timex.format!(date, "{Mfull} {D}, {YYYY}")
IO.puts "\nFetched #{length(licenses)} business licenses whose start dates were after #{readable_date_str}"

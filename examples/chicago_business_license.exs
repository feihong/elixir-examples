# https://developer.foursquare.com/docs/venues/explore

url = "https://data.cityofchicago.org/resource/xqx5-8hwx.json"
app_token = Application.fetch_env!(:examples, BusinessLicense)[:app_token]
date = Timex.shift(Timex.today(), days: -30)
date_str = Timex.format!(date, "{YYYY}-{0M}-{0D}T00:00:00.000")
params = %{
  "$$app_token": app_token,
  license_description: "Retail Food Establishment",
  application_type: "ISSUE",
  license_status: "AAI",
  "$where": "license_start_date > '#{date_str}'"
}

target_activities = [
  "Preparation of Food and Dining on Premise With Seating",
  "Sale of Food Prepared Onsite Without Dining Area"
]

licenses = Download.fetch("business_licenses", url, params)
  |> Enum.filter(fn lic -> lic["business_activity"] in target_activities end)
  |> Enum.sort_by(fn lic -> lic["license_start_date"] end)

for {lic, num} <- Enum.with_index(licenses, 1) do
  IO.puts "#{num}. #{lic["doing_business_as_name"]}"
  IO.puts "    " <> lic["license_start_date"]
  IO.puts "    " <> lic["address"]
end

readable_date_str = Timex.format!(date, "{Mfull} {D}, {YYYY}")
IO.puts "\nFetched #{length(licenses)} business licenses whose start dates were after #{readable_date_str}"

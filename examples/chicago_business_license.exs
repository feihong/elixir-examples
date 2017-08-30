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
  "$where": "date_issued > '#{date_str}'"
}

licenses = Download.fetch("business_licenses", url, params)
for {lic, num} <- Enum.with_index(licenses, 1) do
  IO.puts "#{num}. #{lic["doing_business_as_name"]}"

end

IO.puts "\nFetched #{length(licenses)} business licenses"

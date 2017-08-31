# Browse data:
# https://data.cityofchicago.org/Community-Economic-Development/Business-Licenses/r5kz-chrr/data
# API docs:
# https://dev.socrata.com/foundry/data.cityofchicago.org/xqx5-8hwx

defmodule BusinessLicense do
  @target_activities Application.fetch_env!(:examples, BusinessLicense)[:target_activities]
  @target_neighborhoods Application.fetch_env!(:examples, BusinessLicense)[:target_neighborhoods]
  @neighborhoods Neighborhood.read("chicago-neighborhoods.geojson")
  @keywords Application.fetch_env!(:examples, BusinessLicense)[:keywords]

  def fetch_all(after_date) do
    url = "https://data.cityofchicago.org/resource/xqx5-8hwx.json"
    app_token = Application.fetch_env!(:examples, BusinessLicense)[:app_token]
    date_str = Timex.format!(after_date, "{YYYY}-{0M}-{0D}T00:00:00.000")
    params = %{
      "$$app_token": app_token,
      license_description: "Retail Food Establishment",
      application_type: "ISSUE",
      license_status: "AAI",
      "$where": "license_start_date >= '#{date_str}'"
    }
    Download.fetch("business_licenses", url, params)
      |> Enum.filter(&filter_predicate/1)
      |> Enum.map(&mapper/1)
      |> Enum.sort_by(&sort_map/1)
  end

  defp filter_predicate(lic) do
    biz_activity = lic["business_activity"]
    @target_activities
      |> Enum.any?(fn activity ->
          String.contains?(biz_activity, activity) end)
  end

  defp mapper(lic) do
    hood = if Map.has_key?(lic, "longitude") do
      point = {
        lic["longitude"] |> String.to_float,
        lic["latitude"] |> String.to_float
      }
      find_hood(point)
    else
      "N/A"
    end
    lic |> Map.put("neighborhood", hood)
  end

  defp sort_map(lic) do
    # IO.puts lic["neighborhood"]
    # IO.inspect @target_neighborhoods
    priority = cond do
      lic["neighborhood"] in @target_neighborhoods -> 0
      matches_keyword(lic["doing_business_as_name"]) -> 1
      true -> 2
    end
    {priority, lic["start_date"]}
  end

  defp matches_keyword(name) do
    lower_name = name |> String.downcase
    @keywords
      |> Enum.any?(fn keyword -> String.contains?(lower_name, keyword) end)
  end

  defp find_hood(point) do
    Neighborhood.find_neighborhood(@neighborhoods, point)
  end
end


date = Timex.shift(Timex.today(), months: -3)
licenses = BusinessLicense.fetch_all(date)

for {lic, num} <- Enum.with_index(licenses, 1) do
  IO.puts "#{num}. #{lic["doing_business_as_name"]}"
  IO.puts "    " <> lic["legal_name"]
  hood = if lic["neighborhood"] == nil, do: "N/A", else: lic["neighborhood"]
  IO.puts "    Neighborhood: " <> hood
  # IO.puts "    Ward: " <> lic["ward"]
  # IO.puts "    Activity: " <> lic["business_activity"]
  IO.puts "    " <> lic["license_start_date"]
  IO.puts "    " <> lic["address"]
end

readable_date_str = Timex.format!(date, "{Mfull} {D}, {YYYY}")
IO.puts "\nFetched #{length(licenses)} business licenses whose start dates were after #{readable_date_str}"

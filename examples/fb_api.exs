
defmodule Fetch do
  @keywords Application.fetch_env!(:examples, :keywords)
  @access_token Application.fetch_env!(:examples, Facebook)[:access_token]

  def fetch_all() do
    pages = Application.fetch_env!(:examples, Facebook)[:pages]

    # Fetch all events and sort by start_time.
    events = pages
      |> Enum.map(fn name -> fetch(name) end)
      |> List.flatten
      |> Enum.map(&add_fields/1)
      |> Enum.sort_by(&sort_mapper/1)
  end

  defp fetch(name) do
    cache_name = "facebook__#{name}"
    url = "https://graph.facebook.com/v2.9/#{name}/events/"
    params = %{access_token: @access_token,
               since: DateTime.utc_now |> DateTime.to_iso8601}

    Download.fetch(cache_name, url, params)["data"]
  end

  defp add_fields(evt) do
    text = evt["name"] <> "  " <> evt["description"] |> String.downcase
    matched_keywords = Enum.flat_map(@keywords,
      fn keyword -> if String.contains?(text, keyword) do
          [keyword]
        else
          []
        end
      end)

    evt
      |> Map.put("url", "https://facebook.com/events/#{evt["id"]}")
      |> Map.put("matched_keywords", matched_keywords)
  end

  defp sort_mapper(evt) do
    # Make sure that events that match keywords are always in front
    # regardless of start time.
    num = if length(evt["matched_keywords"]) > 0, do: 0, else: 1
    {num, evt["start_time"]}
  end
end


events = Fetch.fetch_all()
match_count = events
  |> Enum.count(fn evt -> length(evt["matched_keywords"]) > 0 end)

template = "report.slime" |> File.read!
Slime.render(template, events: events, match_count: match_count)
  |> (fn output -> File.write("report.html", output) end).()

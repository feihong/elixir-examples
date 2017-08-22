
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
    text = evt["name"] <> " " <> evt["description"] |> String.downcase
    keyword_match = Enum.any?(@keywords,
      fn keyword -> String.contains?(text, keyword) end)

    evt
      |> Map.put("url", "https://facebook.com/events/#{evt["id"]}")
      |> Map.put("keyword_match", keyword_match)
  end

  defp sort_mapper(evt) do
    # Make sure that events that have desired keywords are always in front
    # regardless of start time.
    num = if evt["keyword_match"], do: 0, else: 1
    {num, evt["start_time"]}
  end
end


template = "report.slime" |> File.read!
Slime.render(template, events: Fetch.fetch_all())
  |> (fn output -> File.write("report.html", output) end).()

defmodule EventBrite do
  @api_key Application.fetch_env!(:examples, EventBrite)[:api_key]

  def fetch_all() do
    pages = Application.fetch_env!(:examples, Facebook)[:pages]

    # Fetch all events and sort.
    events = pages
      |> Enum.map(fn name -> fetch(name) end)
      |> List.flatten
      |> Enum.sort_by(&sort_mapper/1)
  end

  defp fetch(name) do
    cache_name = "facebook__#{name}"
    url = "https://graph.facebook.com/v2.9/#{name}/events/"
    params = %{access_token: @access_token,
               since: DateTime.utc_now |> DateTime.to_iso8601}

    Download.fetch(cache_name, url, params)["data"]
  end

  defp enhance(evt) do
    text = evt["name"] <> "  " <> evt["description"] |> String.downcase
    matched_keywords =
      for keyword <- @keywords,
          String.contains?(text, keyword) do
        keyword
      end

    evt
      |> Map.put("url", "https://facebook.com/events/#{evt["id"]}")
      |> Map.put("matched_keywords", matched_keywords)
      |> Map.put("start_dt", Timex.parse!(evt["start_time"], "{ISO:Extended}"))
  end

  defp sort_mapper(evt) do
    # Make sure that events that match keywords are always in front
    # regardless of start time.
    num = if length(evt["matched_keywords"]) > 0, do: 0, else: 1
    {num, evt["start_time"]}
  end
end

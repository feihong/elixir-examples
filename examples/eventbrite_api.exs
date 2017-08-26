url = "https://www.eventbriteapi.com/v3/users/me/"
token = Application.fetch_env!(:examples, EventBrite)[:access_token]
params = %{token: token}

Download.fetch("eventbrite__me", url, params)

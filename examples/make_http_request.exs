HTTPoison.start
res = HTTPoison.get! "http://ipecho.net/plain"
IO.puts "Your IP address is #{res.body}"

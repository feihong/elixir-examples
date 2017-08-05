
text = File.read! "sample.json"

case Poison.decode text do
  {:ok, %{"author" => author, "text" => text}} ->
    IO.puts "The famous author #{author} wrote \"#{text}\""
  {:error, _} ->
    IO.puts "Something is wrong with the JSON file!"
end

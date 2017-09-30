HanziServer.start_link

IO.puts GenServer.call(HanziServer, 1)
IO.puts HanziServer.get(4)
IO.puts HanziServer.get(2)

# Request HanziServer to print the number of hanzi served.
# GenServer.cast(HanziServer, {})
HanziServer.report

HanziServer.start_link

IO.puts GenServer.call(HanziServer, 1)
IO.puts GenServer.call(HanziServer, 4)
IO.puts GenServer.call(HanziServer, 2)

IO.puts GenServer.cast(HanziServer, {})

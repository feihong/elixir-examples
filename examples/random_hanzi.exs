defmodule HanziServer do
  use GenServer

  defmodule State do
    defstruct count: 0
  end

  def init([]) do
    {:reply, %State{}}
  end

  def handle_call(request, _from, state) do
    count = request
    reply = for _ <- 1..count, do: get_hanzi()
    new_state = %State{count: state.count + 1}
    {:reply, reply, new_state}
  end

  # internal function
  def get_hanzi() do
    Enum.random(0x4e00..0x9fff)
    |> (fn n -> to_string([n]) end)()
  end
end

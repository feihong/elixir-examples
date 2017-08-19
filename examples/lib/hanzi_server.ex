defmodule HanziServer do
  use GenServer

  defmodule State do
    defstruct count: 0
  end

  # This is a convenience method for startup
  def start_link do
    GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  def init([]) do
    {:ok, %State{}}
  end

  def handle_call(request, _from, state) do
    count = request
    reply = for _ <- 1..count, do: get_hanzi()
    new_state = %State{count: state.count + count}
    {:reply, reply, new_state}
  end

  def handle_cast(_msg, state) do
    IO.puts "So far, we have served #{state.count} hanzi"
    {:noreply, state}
  end

  def handle_info(_info, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    {:ok}
  end

  def code_change(_old_version, state, _extra) do
    {:ok, state}
  end

  # internal function
  defp get_hanzi() do
    Enum.random(0x4e00..0x9fff)
    |> (fn n -> to_string([n]) end).()
  end
end
defmodule MiscTest do
  use ExUnit.Case
  doctest Misc

  test "greets the world" do
    assert Misc.hello() == :world
  end
end

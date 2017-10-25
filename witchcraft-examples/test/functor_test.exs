defmodule FunctorTest do
  use ExUnit.Case
  use Witchcraft.Functor

  test "~>" do
    result =
      [1,2,3]
      ~> fn n -> n * 2 end
      ~> fn n -> n + 1 end
    assert result == [3,5,7]
  end

  test "across" do
    result =
      fn n ->
        n * 100 + 1
      end
      |> across(%{a: 1, b: 2, c: 3})
    assert result == %{a: 101, b: 201, c: 301}
  end

  test "replace" do
    replace([1,2,3], 666) == [666,666,666]
  end
end

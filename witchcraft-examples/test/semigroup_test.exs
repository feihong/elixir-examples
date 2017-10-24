defmodule SemigroupTest do
  use ExUnit.Case
  use Witchcraft.Semigroup

  test "list" do
    assert [1, 2] <> [3, 4] == [1, 2, 3, 4]
  end

  test "tuple" do
    assert {1, "a"} <> {2, "b"} == {3, "ab"}
  end

  test "map" do
    m1 = %{a: 1, b: 2}
    m2 = %{b: 333, c: 4}
    assert m1 <> m2 == %{a: 1, b: 333, c: 4}
  end

  test "set" do
    s1 = [1,2,3] |> Enum.into(MapSet.new)
    s2 = Enum.into([2,3,4,5], MapSet.new)
    assert s1 <> s2 == [1,2,3,4,5] |> MapSet.new
  end
end

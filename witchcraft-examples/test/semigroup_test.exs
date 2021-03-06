# https://github.com/expede/witchcraft/blob/master/lib/witchcraft/semigroup.ex

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
    s2 = Enum.into [2,3,4,5], MapSet.new
    assert s1 <> s2 == [1,2,3,4,5] |> MapSet.new
  end

  test "keyword list" do
    l1 = [a: 1, b: 2, c: 3]
    l2 = [a: 11, d: 44, c: 33]
    assert l1 <> l2 == [a: 1, b: 2, c: 3, a: 11, d: 44, c: 33]
  end

  test "function" do
    fn1 = &(&1 + 1)
    fn2 = &(&1 * 2)
    assert (fn1 <> fn2).(4) == 10
  end

  test "append" do
    result =
      [1,2,3]
      |> append([4,5])
      |> append([6,7,8,9])
      |> append([])
      |> append([10])
    assert result == Enum.to_list 1..10
  end

  test "concat" do
    result = concat([
      [1,2,3],
      [4,5],
      [6,7,8],
      [9]
    ])
    assert result == Enum.to_list 1..9
  end

  test "repeat" do
    assert repeat({"a", 3}, times: 3) == {"aaa", 9}
  end
end

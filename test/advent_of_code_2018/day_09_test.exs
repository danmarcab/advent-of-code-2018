defmodule AdventOfCode2018.Day09Test do
  use ExUnit.Case

  import AdventOfCode2018.Day09

  test "part1" do
    examples = [
      {9, 25, 32},
      {10, 1618, 8317},
      {13, 7999, 146_373},
      {17, 1104, 2764},
      {21, 6111, 54718},
      {30, 5807, 37305}
    ]

    for {players, last_marble, expected} <- examples do
      result = part1(players, last_marble)
      assert result == expected
    end
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end

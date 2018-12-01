defmodule AdventOfCode2018.Day01Test do
  use ExUnit.Case

  import AdventOfCode2018.Day01

  test "part1" do
    examples = [
      {[1, 1, 1], 3},
      {[1, 1, -2], 0},
      {[-1, -2, -3], -6}
    ]

    for {input, expected} <- examples do
      result = part1(input)
      assert result == expected
    end
  end

  test "part2" do
    examples = [
      {[1, -1], 0},
      {[3, 3, 4, -2, -4], 10},
      {[-6, 3, 8, 5, -6], 5},
      {[7, 7, -2, -7, -4], 14}
    ]

    for {input, expected} <- examples do
      result = part2(input)
      assert result == expected
    end
  end
end

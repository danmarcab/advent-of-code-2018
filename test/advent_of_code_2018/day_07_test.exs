defmodule AdventOfCode2018.Day07Test do
  use ExUnit.Case

  import AdventOfCode2018.Day07

  test "part1" do
    input =
      """
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
      """
      |> String.split("\n")
      |> Enum.reject(fn el -> el == "" end)

    result = part1(input)

    assert result == "CABDFE"
  end

  test "part2" do
    input =
      """
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
      """
      |> String.split("\n")
      |> Enum.reject(fn el -> el == "" end)

    result = part2(input, 0, 2)

    assert result == {"CABFDE", 15}
  end
end

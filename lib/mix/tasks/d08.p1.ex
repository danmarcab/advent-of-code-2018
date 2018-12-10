defmodule Mix.Tasks.D08.P1 do
  use Mix.Task

  import AdventOfCode2018.Day08

  @shortdoc "Day 08 Part 1"
  def run(_) do
    input =
      File.read!("priv/data/d08.txt")
      |> String.trim()

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end

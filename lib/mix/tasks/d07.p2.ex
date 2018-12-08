defmodule Mix.Tasks.D07.P2 do
  use Mix.Task

  import AdventOfCode2018.Day07

  @shortdoc "Day 07 Part 2"
  def run(_) do
    input =
      File.stream!("priv/data/d07.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part2(60, 5)
    |> IO.inspect(label: "Part 2 Results")
  end
end

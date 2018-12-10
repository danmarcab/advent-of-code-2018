defmodule Mix.Tasks.D09.P2 do
  use Mix.Task

  import AdventOfCode2018.Day09

  @shortdoc "Day 09 Part 2"
  def run(_) do
    part1(424, 7_114_400)
    |> IO.inspect(label: "Part 2 Results")

    Benchee.run(%{
      "benchmark" => fn -> part1(424, 7_114_400) end
    })
  end
end

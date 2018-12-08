defmodule Mix.Tasks.D05.P2 do
  use Mix.Task

  import AdventOfCode2018.Day05

  @shortdoc "Day 05 Part 2"
  def run(_) do
    input =
      File.read!("priv/data/d05.txt")
      |> String.trim()

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")

    Benchee.run(%{
      "benchmark" => fn -> part2(input) end
    })
  end
end

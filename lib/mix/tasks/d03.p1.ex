defmodule Mix.Tasks.D03.P1 do
  use Mix.Task

  import AdventOfCode2018.Day03

  @shortdoc "Day 03 Part 1"
  def run(_) do
    input =
      File.stream!("priv/data/d03.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")

    Benchee.run(%{
      "benchmark" => fn -> part1(input) end
    })
  end
end

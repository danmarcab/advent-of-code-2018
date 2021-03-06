defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode2018.Day02

  @shortdoc "Day 02 Part 1"
  def run(_) do
    input =
      File.stream!("priv/data/d02.p1.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")

    Benchee.run(%{
      "benchmark" => fn -> part1(input) end
    })
  end
end

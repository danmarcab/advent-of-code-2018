defmodule Mix.Tasks.D02.P2 do
  use Mix.Task

  import AdventOfCode2018.Day02

  @shortdoc "Day 02 Part 2"
  def run(_) do
    input =
      File.stream!("priv/data/d02.p1.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")

    Benchee.run(%{
      "benchmark" => fn -> part2(input) end
    })
  end
end

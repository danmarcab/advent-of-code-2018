defmodule Mix.Tasks.D01.P2 do
  use Mix.Task

  import AdventOfCode2018.Day01

  @shortdoc "Day 01 Part 2"
  def run(_) do
    input =
      File.stream!("priv/data/d01.p1.txt")
      |> Stream.map(&String.trim/1)
      |> Stream.map(fn str ->
        {int, ""} = Integer.parse(str)
        int
      end)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")

    Benchee.run(%{
      "benchmark" => fn -> part2(input) end
    })
  end
end

defmodule AdventOfCode2018.Day01 do
  def part1(args) do
    Enum.sum(args)
  end

  def part2(args) do
    args
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn change, {frequency, frequencies_seen} ->
      new_frequency = frequency + change

      case Enum.member?(frequencies_seen, new_frequency) do
        true -> {:halt, new_frequency}
        false -> {:cont, {new_frequency, MapSet.put(frequencies_seen, new_frequency)}}
      end
    end)
  end
end

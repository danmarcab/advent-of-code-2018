defmodule AdventOfCode2018.Day02 do
  def part1(args) do
    Enum.reduce(args, {0, 0}, fn word, {twos, threes} ->
      counted_items =
        word
        |> String.graphemes()
        |> with_count()

      {inc_if(twos, has_item_count(counted_items, 2)),
       inc_if(threes, has_item_count(counted_items, 3))}
    end)
    |> (fn {twos, threes} -> twos * threes end).()
  end

  def part2(args) do
    words =
      args
      |> Enum.to_list()

    # assume all words are same length
    length = String.length(List.first(words))

    Enum.reduce_while(1..length, nil, fn n, nil ->
      words
      |> Enum.map(fn word -> String.slice(word, 0, n - 1) <> String.slice(word, n, length) end)
      |> with_count
      |> Enum.find(fn {_, count} -> count == 2 end)
      |> (fn
            nil -> {:cont, nil}
            {value, 2} -> {:halt, value}
          end).()
    end)
  end

  defp with_count(enum) do
    Enum.reduce(enum, %{}, fn el, acc ->
      Map.update(acc, el, 1, &(&1 + 1))
    end)
  end

  defp has_item_count(items_with_count, n) do
    Enum.any?(items_with_count, fn {_, count} -> count == n end)
  end

  defp inc_if(n, true), do: n + 1
  defp inc_if(n, false), do: n
end

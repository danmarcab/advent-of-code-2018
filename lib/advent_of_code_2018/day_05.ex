defmodule AdventOfCode2018.Day05 do
  def part1(args) do
    react(args, <<>>, {nil, nil})
    |> String.length()
  end

  def part2(args) do
    Enum.map(?a..?z, fn c ->
      react(args, <<>>, {c, c - 32})
      |> String.length()
    end)
    |> Enum.min()
  end

  defp react(<<>>, reversed, to_remove), do: String.reverse(reversed)

  defp react(<<char::utf8, rest::binary>>, acc, {char, upp}) do
    react(rest, acc, {char, upp})
  end

  defp react(<<char::utf8, rest::binary>>, acc, {low, char}) do
    react(rest, acc, {low, char})
  end

  defp react(<<char::utf8, rest::binary>>, <<>>, to_remove) do
    react(rest, <<char::utf8>>, to_remove)
  end

  defp react(<<char::utf8, rest::binary>>, <<first_acc::utf8, rest_acc::binary>>, to_remove) do
    if abs(char - first_acc) == 32 do
      react(<<rest::binary>>, <<rest_acc::binary>>, to_remove)
    else
      react(<<rest::binary>>, <<char::utf8, first_acc::utf8, rest_acc::binary>>, to_remove)
    end
  end
end

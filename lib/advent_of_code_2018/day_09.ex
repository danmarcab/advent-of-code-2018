defmodule AdventOfCode2018.Day09 do
  def part1(n_players, last_marble) do
    initial_ring = {[], []} |> insert(0)

    initial_players =
      for n <- 1..n_players do
        {n, 0}
      end
      |> Enum.into(%{})

    Enum.reduce(1..last_marble, {initial_ring, initial_players, 1}, fn marble,
                                                                       {ring, players,
                                                                        current_player} ->
      {new_ring, new_players} =
        if rem(marble, 23) == 0 do
          {new_ring, popped} =
            ring
            |> move_ccw(7)
            |> pop

          new_players =
            Map.update(players, current_player, popped + marble, &(&1 + popped + marble))

          {new_ring, new_players}
        else
          new_ring =
            ring
            |> move_cw(2)
            |> insert(marble)

          {new_ring, players}
        end

      #      print(current_player, new_ring)
      {new_ring, new_players, rem(current_player, n_players) + 1}
      #      |> IO.inspect()
    end)
    |> (fn {ring, players, current_player} ->
          Enum.max_by(players, fn {_, count} -> count end, fn -> {nil, 0} end)
          |> elem(1)
        end).()
  end

  def part2(args) do
  end

  defp move_cw(ring, 0), do: ring
  defp move_cw({[], []}, n), do: {[], []}
  defp move_cw({ccw, []}, n), do: move_cw({[], Enum.reverse(ccw)}, n)
  defp move_cw({ccw, [first_cw | rest_cw]}, n), do: move_cw({[first_cw | ccw], rest_cw}, n - 1)

  defp move_ccw(ring, 0), do: ring
  defp move_ccw({[], []}, n), do: {[], []}
  defp move_ccw({[], cw}, n), do: move_ccw({Enum.reverse(cw), []}, n)

  defp move_ccw({[first_ccw | rest_ccw], cw}, n),
    do: move_ccw({rest_ccw, [first_ccw | cw]}, n - 1)

  defp insert({ccw, cw}, marble) do
    {ccw, [marble | cw]}
  end

  defp pop({ccw, [first_cw | rest_cw]}), do: {{ccw, rest_cw}, first_cw}
  defp pop({ccw, []}), do: pop({[], Enum.reverse(ccw)})

  defp print(player, {ccw, cw}) do
    IO.puts("")

    [
      "[#{player}]"
      | (Enum.reverse(ccw) ++ cw)
        |> Enum.map(fn n -> Integer.to_string(n) |> String.pad_leading(2) end)
    ]
    |> Enum.join(" ")
    |> IO.puts()
  end
end

defmodule AdventOfCode2018.Day03 do
  defmodule MyParser do
    import NimbleParsec

    def to_claim([id, x, y, w, h]) do
      %{id: id, x: x, y: y, w: w, h: h}
    end

    claim =
      ignore(string("#"))
      |> integer(min: 1)
      |> ignore(string(" @ "))
      |> integer(min: 1)
      |> ignore(string(","))
      |> integer(min: 1)
      |> ignore(string(": "))
      |> integer(min: 1)
      |> ignore(string("x"))
      |> integer(min: 1)
      |> reduce(:to_claim)

    defparsec(:claim, claim)
  end

  def part1(args) do
    args
    |> expand_claims
    |> build_fabric
    |> Enum.count(fn {_, count} -> count >= 2 end)
  end

  def part2(args) do
    expanded_claims = expand_claims(args)
    fabric = build_fabric(expanded_claims)

    Enum.find(expanded_claims, fn %{coords: coords} ->
      Enum.all?(coords, fn coord ->
        Map.get(fabric, coord) == 1
      end)
    end)[:id]
  end

  defp expand_claims(args) do
    args
    |> Stream.map(&parse_claim/1)
    |> Stream.map(&add_coords_to_claim/1)
  end

  defp parse_claim(line) do
    {:ok, [claim], _, _, _, _} = MyParser.claim(line)

    claim
  end

  defp build_fabric(claims) do
    Enum.reduce(claims, %{}, fn claim, fabric ->
      Enum.reduce(claim[:coords], fabric, fn coord, acc ->
        Map.update(acc, coord, 1, &(&1 + 1))
      end)
    end)
  end

  defp add_coords_to_claim(%{id: id, x: x, y: y, w: w, h: h} = claim) do
    coords =
      for claim_x <- x..(x + w - 1), claim_y <- y..(y + h - 1) do
        {claim_x, claim_y}
      end

    Map.put(claim, :coords, coords)
  end
end

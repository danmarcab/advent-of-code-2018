defmodule AdventOfCode2018.Day06 do
  defmodule MyParser do
    import NimbleParsec

    def to_coord([x, y]) do
      {x, y}
    end

    coord =
      integer(min: 1)
      |> ignore(string(", "))
      |> integer(min: 1)
      |> reduce(:to_coord)

    defparsec(:coord, coord)

    def parse_line(line) do
      {:ok, [coord], _, _, _, _} = coord(line)
      coord
    end
  end

  def part1(args) do
    coords =
      args
      |> Stream.map(&MyParser.parse_line/1)

    {{minX, _}, {maxX, _}} = Enum.min_max_by(coords, fn {x, _} -> x end)
    {{_, minY}, {_, maxY}} = Enum.min_max_by(coords, fn {_, y} -> y end)

    coords_with_name =
      coords
      |> Stream.with_index(?a)
      |> Enum.map(fn {{x, y}, name} ->
        {<<name::utf8>>, {x, y}}
      end)

    grid =
      for x <- (minX - 1)..(maxX + 1), y <- (minY - 1)..(maxY + 1) do
        {{x, y}, closest_to({x, y}, coords_with_name)}
      end
      |> Enum.into(%{})

    # print_grid(grid, {{minX, minY}, {maxX, maxY}})

    dont_count =
      MapSet.new([<<0>>]) |> MapSet.union(in_borders(grid, {{minX, minY}, {maxX, maxY}}))

    count_by_name(grid)
    |> Map.drop(dont_count)
    |> max_by_count
  end

  def part2(args, max_sum) do
    coords =
      args
      |> Stream.map(&MyParser.parse_line/1)

    {{minX, _}, {maxX, _}} = Enum.min_max_by(coords, fn {x, _} -> x end)
    {{_, minY}, {_, maxY}} = Enum.min_max_by(coords, fn {_, y} -> y end)

    grid =
      for x <- (minX - 1)..(maxX + 1), y <- (minY - 1)..(maxY + 1) do
        {{x, y}, sum_distances({x, y}, coords)}
      end
      |> Enum.filter(fn {_coord, sum_dist} -> sum_dist < max_sum end)
      |> Enum.count()
  end

  defp manhattan_dist({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  defp closest_to({x, y}, coords) do
    Enum.reduce_while(coords, {nil, 1_000_000_000_000}, fn
      {name, {^x, ^y}}, _ ->
        {:halt, {name, 0}}

      {name, {coord_x, coord_y}}, {closest_name, closest_distance} ->
        dist = manhattan_dist({x, y}, {coord_x, coord_y})

        #        IO.inspect({{x, y}, name, {coord_x, coord_y}, {closest_name, closest_distance}, dist})

        case closest_distance - dist do
          0 ->
            {:cont, {<<0>>, dist}}

          n when n > 0 ->
            {:cont, {name, dist}}

          n when n < 0 ->
            {:cont, {closest_name, closest_distance}}
        end
    end)
  end

  defp sum_distances(target_coord, coords) do
    Enum.reduce(coords, 0, fn coord, acc ->
      acc + manhattan_dist(target_coord, coord)
    end)
  end

  defp count_by_name(grid) do
    Enum.reduce(grid, %{}, fn {coord, {name, _dist}}, counts ->
      Map.update(counts, name, 1, &(&1 + 1))
    end)
  end

  defp print_grid(grid, {{minX, minY}, {maxX, maxY}}) do
    IO.write("\n")

    for y <- (minY - 1)..(maxY + 1) do
      for x <- (minX - 1)..(maxX + 1) do
        {name, dist} = Map.get(grid, {x, y})

        case Map.get(grid, {x, y}) do
          {<<0>>, _dist} ->
            IO.write(".")

          {name, 0} ->
            IO.write(String.upcase(name))

          {name, _dist} ->
            IO.write(name)
        end
      end

      IO.write("\n")
    end
  end

  defp in_borders(grid, {{minX, minY}, {maxX, maxY}}) do
    inTopBottom =
      (minX - 1)..(maxX + 1)
      |> Enum.reduce(MapSet.new(), fn x, names ->
        names
        |> MapSet.put(Map.get(grid, {x, minY}) |> elem(0))
        |> MapSet.put(Map.get(grid, {x, maxY}) |> elem(0))
      end)

    inLeftRight =
      (minY - 1)..(maxY + 1)
      |> Enum.reduce(MapSet.new(), fn y, names ->
        names
        |> MapSet.put(Map.get(grid, {minX, y}) |> elem(0))
        |> MapSet.put(Map.get(grid, {maxX, y}) |> elem(0))
      end)

    MapSet.union(inTopBottom, inLeftRight)
  end

  defp max_by_count(data) do
    Enum.max_by(data, fn {_, count} -> count end, fn -> {nil, 0} end)
  end
end

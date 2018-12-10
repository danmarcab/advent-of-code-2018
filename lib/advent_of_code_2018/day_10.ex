defmodule AdventOfCode2018.Day10 do
  defmodule MyParser do
    import NimbleParsec

    def to_point([x, y, vx, vy]) do
      %{x: x, y: y, vx: vx, vy: vy}
    end

    def minus([n]), do: -n

    #                       position=<-40178,  -9913> velocity=< 4,  1>

    int = choice([integer(min: 1), ignore(string("-")) |> integer(min: 1) |> reduce(:minus)])

    spaces = ignore(repeat(string(" ")))

    point =
      ignore(string("position=<"))
      |> concat(spaces)
      |> concat(int)
      |> ignore(string(","))
      |> concat(spaces)
      |> concat(int)
      |> ignore(string("> velocity=<"))
      |> concat(spaces)
      |> concat(int)
      |> ignore(string(","))
      |> concat(spaces)
      |> concat(int)
      |> ignore(string(">"))
      |> reduce(:to_point)

    defparsec(:point, point)

    def parse_line(line) do
      {:ok, [point], _, _, _, _} = point(line)
      point
    end
  end

  def part1(args) do
    points =
      args
      |> Stream.map(&MyParser.parse_line/1)

    advance_until_collapsed(points, nil, 0)
  end

  defp advance_until_collapsed(points, prev_area, time) do
    #    grid =
    #      Enum.map(points, fn point -> {point.x, point.y} end)
    #      |> Enum.into(MapSet.new())
    #
    #    print_grid(grid, {{-20, -20}, {20, 20}})
    #
    new_points =
      points
      |> Enum.map(&move/1)

    {%{x: minX}, %{x: maxX}} = Enum.min_max_by(new_points, fn %{x: x} -> x end)
    {%{y: minY}, %{y: maxY}} = Enum.min_max_by(new_points, fn %{y: y} -> y end)

    #    IO.inspect("#{minX} - #{maxX}")
    #    IO.inspect("#{minY} - #{maxY}")
    new_area = (maxX - minX) * (maxY - minY)

    #    IO.inspect(new_area)

    if new_area < prev_area do
      advance_until_collapsed(new_points, new_area, time + 1)
    else
      grid =
        Enum.map(points, fn point -> {point.x, point.y} end)
        |> Enum.into(MapSet.new())

      {%{x: minX}, %{x: maxX}} = Enum.min_max_by(points, fn %{x: x} -> x end)
      {%{y: minY}, %{y: maxY}} = Enum.min_max_by(points, fn %{y: y} -> y end)

      print_grid(grid, {{minX, minY}, {maxX, maxY}})

      {new_points, prev_area, time}
    end
  end

  defp move(%{x: x, y: y, vx: vx, vy: vy}) do
    %{x: x + vx, y: y + vy, vx: vx, vy: vy}
  end

  defp print_grid(grid, {{minX, minY}, {maxX, maxY}}) do
    IO.write("\n")

    for y <- (minY - 1)..(maxY + 1) do
      for x <- (minX - 1)..(maxX + 1) do
        case MapSet.member?(grid, {x, y}) do
          true ->
            IO.write("X")

          false ->
            IO.write(".")
        end
      end

      IO.write("\n")
    end
  end

  def part2(args) do
  end
end

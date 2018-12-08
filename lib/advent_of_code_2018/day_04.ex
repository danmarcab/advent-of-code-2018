defmodule AdventOfCode2018.Day04 do
  defmodule MyParser do
    import NimbleParsec

    def to_map([y, mo, d, h, m, "wakes up"]) do
      %{date: {y, mo, d}, time: {h, m}, action: :wake_up}
    end

    def to_map([y, mo, d, h, m, "falls asleep"]) do
      %{date: {y, mo, d}, time: {h, m}, action: :sleep}
    end

    def to_map([y, mo, d, h, m, guard_id]) when is_integer(guard_id) do
      %{date: {y, mo, d}, time: {h, m}, guard: guard_id}
    end

    action =
      ignore(string("["))
      |> integer(min: 1)
      |> ignore(string("-"))
      |> integer(min: 1)
      |> ignore(string("-"))
      |> integer(min: 1)
      |> ignore(string(" "))
      |> integer(min: 1)
      |> ignore(string(":"))
      |> integer(min: 1)
      |> ignore(string("] "))
      |> choice([
        ignore(string("Guard #"))
        |> integer(min: 1)
        |> ignore(string(" begins shift")),
        string("falls asleep"),
        string("wakes up")
      ])
      |> reduce(:to_map)

    defparsec(:action, action)
  end

  def part1(args) do
    schedule = build_schedule(args)

    {guard_with_more_mins, _} =
      calc_minutes_per_guard(schedule)
      |> max_by_count()

    filter_schedule_by_guard(schedule, guard_with_more_mins)
    |> most_slept_minute()
    |> calc_solution()
  end

  def part2(args) do
    build_schedule(args)
    |> most_slept_minute()
    |> calc_solution()
  end

  defp build_schedule(args) do
    {_, schedule} =
      args
      |> Stream.map(&parse_line/1)
      |> Enum.sort_by(&{&1.date, &1.time})
      |> Enum.reduce({nil, %{}}, fn
        %{date: date, time: time, guard: guard_id}, {current_guard, acc} ->
          {guard_id, acc}

        %{date: date, time: time, action: action}, {current_guard, acc} ->
          {current_guard,
           Map.update(acc, date, %{guard: current_guard, actions: %{time => action}}, fn map ->
             put_in(map, [:actions, time], action)
           end)}
      end)

    schedule
  end

  defp calc_minutes_per_guard(schedule) do
    Enum.reduce(schedule, %{}, fn {date, data}, acc ->
      minutes =
        data.actions
        |> Map.keys()
        |> Enum.chunk_every(2)
        |> Enum.map(fn [{0, l}, {0, h}] ->
          h - l
        end)
        |> Enum.sum()

      Map.update(acc, data.guard, minutes, &(&1 + minutes))
    end)
  end

  defp parse_line(line) do
    {:ok, [action], _, _, _, _} = MyParser.action(line)
    action
  end

  defp filter_schedule_by_guard(schedule, guard) do
    schedule
    |> Enum.filter(fn {date, day_schedule} ->
      day_schedule.guard == guard
    end)
    |> Enum.into(%{})
  end

  defp most_slept_minute(schedule) do
    Enum.reduce(0..59, {nil, nil, 0}, fn min, {current_guard, current_min_max, current_max} ->
      data = check_minute(min, schedule)
      {guard, count} = Enum.max_by(data, fn {_, count} -> count end, fn -> {nil, 0} end)

      if count > current_max do
        {guard, min, count}
      else
        {current_guard, current_min_max, current_max}
      end
    end)
  end

  defp check_minute(min, actions) do
    Enum.reduce(actions, %{}, fn {date, data}, acc ->
      if(sleeping?(min, data.actions)) do
        Map.update(acc, data.guard, 1, &(&1 + 1))
      else
        acc
      end
    end)
  end

  defp sleeping?(min, actions) do
    actions
    |> Map.keys()
    |> Enum.chunk_every(2)
    |> Enum.any?(fn [{0, l}, {0, h}] ->
      min >= l && min < h
    end)
  end

  defp max_by_count(data) do
    Enum.max_by(data, fn {_, count} -> count end, fn -> {nil, 0} end)
  end

  defp calc_solution({guard, minute, _times_slept}), do: guard * minute
end

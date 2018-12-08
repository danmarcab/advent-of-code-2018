defmodule AdventOfCode2018.Day07 do
  def part1(args) do
    args
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {step, dependency_step}, deps ->
      deps
      |> Map.update(step, MapSet.new([dependency_step]), &MapSet.put(&1, dependency_step))
      |> Map.put_new(dependency_step, MapSet.new())
    end)
    |> Stream.unfold(fn deps ->
      if Enum.empty?(deps) do
        nil
      else
        pick_next(deps)
      end
    end)
    |> Enum.to_list()
    |> Enum.join()
  end

  def part2(args, step_delay, n_workers) do
    args
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {step, dependency_step}, deps ->
      deps
      |> Map.update(step, MapSet.new([dependency_step]), &MapSet.put(&1, dependency_step))
      |> Map.put_new(dependency_step, MapSet.new())
    end)
    |> reduce(step_delay, for(n <- 1..n_workers, do: :free), [], 0)
  end

  defp parse_line(
         <<"Step ", dependency_step::utf8, " must be finished before step ", step::utf8,
           " can begin.">>
       ) do
    {[step], [dependency_step]}
  end

  defp pick_next(deps) do
    next_step =
      deps
      |> Enum.filter(fn {step, step_deps} ->
        Enum.empty?(step_deps)
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sort()
      |> List.first()

    updated_deps = apply_step(deps, next_step)

    {next_step, updated_deps}
  end

  defp apply_step(deps, step_to_apply) do
    deps
    |> Map.delete(step_to_apply)
    |> Enum.map(fn {step, step_deps} ->
      {step, MapSet.delete(step_deps, step_to_apply)}
    end)
    |> Enum.into(%{})
  end

  defp reduce(deps, delay, workers, acc, current_time) when deps == %{} do
    {completed, time_to_finish} = finish_work(workers)
    {(acc ++ completed) |> Enum.join(), current_time + time_to_finish - 1}
  end

  defp reduce(deps, delay, workers, acc, current_time) do
    {finished, new_workers} = work(workers)

    updated_deps = complete_steps(deps, finished)

    available_steps = available_steps(updated_deps)

    {taken, new_workers, _still_available} = prepare_work(new_workers, available_steps, delay)

    updated_deps = take_steps(updated_deps, taken)

    #    IO.puts(
    #      "#{Integer.to_string(current_time) |> String.pad_leading(5)}  #{
    #        new_workers
    #        |> Enum.map(fn
    #          :free -> '.'
    #          {:working, step, _} -> step
    #        end)
    #        |> Enum.join("  ")
    #      }  #{acc ++ Enum.to_list(finished)}"
    #    )

    reduce(updated_deps, delay, new_workers, acc ++ Enum.to_list(finished), current_time + 1)
  end

  defp work(workers) do
    Enum.reduce(workers, {MapSet.new(), []}, fn
      :free, {completed, updated_workers} ->
        {completed, updated_workers ++ [:free]}

      {:working, step, 1}, {completed, updated_workers} ->
        {MapSet.put(completed, step), updated_workers ++ [:free]}

      {:working, step, n}, {completed, updated_workers} ->
        {completed, updated_workers ++ [{:working, step, n - 1}]}
    end)
  end

  defp prepare_work(workers, available, delay) do
    Enum.reduce(workers, {[], [], available}, fn
      :free, {taken, updated_workers, []} ->
        {taken, updated_workers ++ [:free], []}

      :free, {taken, updated_workers, [step | more_steps]} ->
        {[step | taken], updated_workers ++ [{:working, step, duration_for(step, delay)}],
         more_steps}

      worker, {taken, updated_workers, available} ->
        {taken, updated_workers ++ [worker], available}
    end)
  end

  defp finish_work(workers) do
    ordered_to_finish =
      workers
      |> Enum.filter(fn
        :free -> false
        other -> true
      end)
      |> Enum.sort_by(fn {:working, step, time_left} -> time_left end)

    finish_order = ordered_to_finish |> Enum.map(fn {:working, step, _} -> step end)

    time_to_finish =
      ordered_to_finish
      |> Enum.max_by(fn {:working, step, time_left} -> time_left end)
      |> (fn {:working, _, time} -> time end).()

    {finish_order, time_to_finish}
  end

  defp duration_for([char], delay) do
    delay + (char - 64)
  end

  defp complete_steps(deps, completed) do
    deps
    |> Enum.map(fn {step, step_deps} ->
      {step, MapSet.difference(step_deps, completed)}
    end)
    |> Enum.into(%{})
  end

  defp take_steps(deps, to_take) do
    deps
    |> Map.drop(to_take)
  end

  defp available_steps(deps) do
    deps
    |> Enum.filter(fn {step, step_deps} ->
      Enum.empty?(step_deps)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort()
  end
end

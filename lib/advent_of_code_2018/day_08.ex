defmodule AdventOfCode2018.Day08 do
  def part1(args) do
    num_list =
      args
      |> String.split(" ")
      |> Enum.map(fn str ->
        {int, _} = Integer.parse(str)
        int
      end)

    {tree, []} = build_tree(num_list)

    sum_metadata(tree)
  end

  defp build_tree([num_children, num_metadata | rest]) do
    {children, remaining_after_children} = build_children(num_children, [], rest)

    {metadata, remaining_after_metadata} = Enum.split(remaining_after_children, num_metadata)

    {%{children: children, metadata: metadata}, remaining_after_metadata}
  end

  defp build_children(0, children, remaining) do
    {Enum.reverse(children), remaining}
  end

  defp build_children(n, children, remaining) do
    {child, remaining_after_child} = build_tree(remaining)
    build_children(n - 1, [child | children], remaining_after_child)
  end

  defp sum_metadata(%{children: children, metadata: metadata}) do
    [Enum.sum(metadata) | Enum.map(children, &sum_metadata/1)]
    |> Enum.sum()
  end

  def part2(args) do
    num_list =
      args
      |> String.split(" ")
      |> Enum.map(fn str ->
        {int, _} = Integer.parse(str)
        int
      end)

    {tree, []} = build_tree(num_list)

    sum_nodes(tree)
  end

  defp sum_nodes(%{children: [], metadata: metadata}) do
    Enum.sum(metadata)
  end

  defp sum_nodes(%{children: children, metadata: metadata}) do
    Enum.map(metadata, fn idx ->
      case Enum.at(children, idx - 1) do
        nil -> 0
        child -> sum_nodes(child)
      end
    end)
    |> Enum.sum()
  end
end

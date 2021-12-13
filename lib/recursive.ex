defmodule Recursion do
  def recur(edges) do
    recur(edges["start"], edges, MapSet.new(["start"]), ["start"], 0)
  end

  defp recur(["end" | caves], edges, seen, path, count) do
    recur(caves, edges, seen, path, count + 1)
  end

  defp recur([cave | caves], edges, seen, path, count) do
    count =
      cond do
        cave in seen ->
          count

        smallcave?(cave) ->
          recur(edges[cave], edges, MapSet.put(seen, cave), [cave | path], count)

        true ->
          recur(edges[cave], edges, seen, [cave | path], count)
      end

    recur(caves, edges, seen, path, count)
  end

  defp recur([], _edges, _seen, _path, count) do
    count
  end

  defp smallcave?(cave), do: String.downcase(cave, :ascii) == cave
end

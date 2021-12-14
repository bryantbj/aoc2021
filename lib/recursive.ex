defmodule Recursion do
  def recur(edges) do
    recur(edges["start"], edges, MapSet.new(["start"]), false, ["start"], 0)
  end

  defp recur(["end" | caves], edges, seen, once?, path, count) do
    recur(caves, edges, seen, once?, path, count + 1)
  end

  defp recur([cave | caves], edges, seen, once?, path, count) do
    count =
      cond do
        cave == "start" or (cave in seen and once?) ->
          count

        cave in seen ->
          recur(edges[cave], edges, MapSet.put(seen, cave), true, [cave | path], count)

        smallcave?(cave) ->
          recur(edges[cave], edges, MapSet.put(seen, cave), once?, [cave | path], count)

        true ->
          recur(edges[cave], edges, seen, once?, [cave | path], count)
      end

    recur(caves, edges, seen, once?, path, count)
  end

  defp recur([], _edges, _seen, _path, _once?, count) do
    count
  end

  defp smallcave?(cave), do: String.downcase(cave, :ascii) == cave
end

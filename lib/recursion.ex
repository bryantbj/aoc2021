defmodule Recursion do
  def basin(point, grid) do
    basin(MapSet.new(), point, grid)
  end

  defp basin(set, {row, col} = point, grid) do
    if grid[point] in [9, nil] or point in set do
      set
    else
      set
      |> MapSet.put(point)
      |> basin({row - 1, col}, grid)
      |> basin({row + 1, col}, grid)
      |> basin({row, col - 1}, grid)
      |> basin({row, col + 1}, grid)
    end
  end
end

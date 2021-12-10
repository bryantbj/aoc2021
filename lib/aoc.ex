defmodule Aoc do
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    grid =
      for {line, row} <- Enum.with_index(String.split(input, ~r/\s+/, trim: true)),
          {number, col} <- Enum.with_index(String.to_charlist(line)),
          into: %{} do
        {{row, col}, number - ?0}
      end

    grid
    |> Enum.filter(fn {{row, col}, value} ->
      up = grid[{row + 1, col}]
      down = grid[{row - 1, col}]
      left = grid[{row, col - 1}]
      right = grid[{row, col + 1}]

      value < up and value < down and value < left and value < right
    end)
    |> Enum.map(fn {_, value} -> value + 1 end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

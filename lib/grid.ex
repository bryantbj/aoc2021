defmodule Grid do
  defstruct grid: %{}, flashes: 0, sync: 0

  def new(input) do
    grid =
      for {line, row} <- Enum.with_index(String.split(input, ~r/\s+/, trim: true)),
          {energy, col} <- Enum.with_index(String.to_charlist(line)),
          into: %{},
          do: {{row, col}, energy - ?0}

    %Grid{grid: grid, flashes: 0, sync: 0}
  end

  def neighbors(%{grid: grid}, {x, y}) do
    [
      {x - 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1},
      {x + 1, y},
      {x + 1, y - 1},
      {x, y - 1},
      {x - 1, y - 1}
    ]
    |> Enum.filter(&grid[&1])
  end

  def step(grid) do
    grid =
      for {pos, _val} <- grid.grid,
          reduce: grid do
        grid -> inc(grid, pos)
      end

    for {pos, val} <- grid.grid,
        val > 9,
        reduce: grid do
      grid ->
        flash(grid, pos)
    end
  end

  def flash(grid, pos, flashed \\ MapSet.new()) do
    if pos in flashed or grid.grid[pos] < 10 do
      grid
    else
      grid =
        grid
        |> reset(pos)
        |> Map.update(:flashes, 1, &(&1 + 1))

      flashed = MapSet.put(flashed, pos)

      grid =
        case Enum.all?(grid.grid, fn {_pos, val} -> val == 0 end) do
          true -> Map.put(grid, :sync, true)
          _ -> grid
        end

      charge(grid, neighbors(grid, pos), flashed)
    end
  end

  def charge(grid, list_of_positions, flashed) do
    grid =
      for pos <- list_of_positions,
          pos not in flashed,
          grid.grid[pos] > 0,
          reduce: grid do
        grid ->
          inc(grid, pos)
      end

    for pos <- list_of_positions,
        grid.grid[pos] > 9,
        pos not in flashed,
        reduce: grid do
      grid -> flash(grid, pos, flashed)
    end
  end

  def inc(grid, pos) do
    update_in(grid, Enum.map([:grid, pos], &Access.key/1), &(&1 + 1))
  end

  def reset(grid, pos) do
    update_in(grid, Enum.map([:grid, pos], &Access.key(&1)), fn _ -> 0 end)
  end
end

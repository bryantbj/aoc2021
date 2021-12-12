defmodule Aoc do
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    grid =
      input
      |> Grid.new()

    grid =
      1..100
      |> Enum.reduce(grid, fn _n, grid ->
        Grid.step(grid)
      end)

    IO.inspect(grid.flashes)
  end

  def test() do
    run("5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526")
  end
end

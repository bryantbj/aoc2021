defmodule Aoc do
  def test() do
    run("""
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """)
  end

  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    {grid, folds} =
      input
      |> parse()

    folds = [hd(folds)]

    Enum.reduce(folds, grid, fn {axis, val}, grid ->
      Enum.map(grid, fn {x, y} ->
        case axis do
          "x" ->
            (x > val and {val - (x - val), y}) || {x, y}

          "y" ->
            (y > val and {x, val - (y - val)}) || {x, y}
        end
      end)
      |> Enum.uniq()
    end)
    |> Enum.count(& &1)
    |> IO.inspect()
  end

  def parse(input) do
    [grid, folds] =
      input
      |> String.split(~r/\n\n/, trim: true)

    grid =
      for line <- String.split(grid, "\n", trim: true),
          char <- String.split(line, ",", trim: true) do
        String.to_integer(char)
      end
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple/1)

    folds =
      Regex.scan(~r/([yx])=(\d+)/, folds)
      |> Enum.filter(&(length(&1) > 0))
      |> Enum.map(&tl/1)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.map(fn {direction, val} -> {direction, String.to_integer(val)} end)

    {grid, folds}
  end
end

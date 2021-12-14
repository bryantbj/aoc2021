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
    |> printer()
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

  def printer(grid) do
    {xs, ys} =
      Enum.reduce(grid, {}, fn
        {x, y}, {} ->
          {[x], [y]}

        {x, y}, {xs, ys} ->
          {[x | xs], [y | ys]}
      end)

    x_max = Enum.max(xs)
    y_max = Enum.max(ys)

    template = Enum.map(0..x_max, fn _ -> "." end) |> List.to_tuple()
    builder = Enum.reduce(0..y_max, {}, fn _, acc -> Tuple.append(acc, template) end)

    builder =
      for {y, x} <- grid, reduce: builder do
        builder ->
          put_in(builder, [Access.elem(x), Access.elem(y)], "#")
      end

    message =
      builder
      |> Tuple.to_list()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.join("\n")

    IO.puts("\n")
    IO.puts(message)
  end
end

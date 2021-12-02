defmodule Aoc do
  @doc """
  ## Examples
    iex> Aoc.run("forward 5
    ...>          down 5
    ...>          forward 8
    ...>          up 3
    ...>          down 8
    ...>          forward 2")
    150
  """
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> clean()
    |> countem()
    |> IO.inspect()
  end

  def clean(string) do
    string
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(String.length(&1) > 0))
    |> Stream.map(fn
      "forward " <> num -> {String.to_integer(num), 0}
      "down " <> num -> {0, String.to_integer(num)}
      "up " <> num -> {0, -1 * String.to_integer(num)}
    end)
  end

  def countem(list) do
    list
    |> Enum.reduce({0, 0}, fn {x, y}, {acc_x, acc_y} ->
      {acc_x + x, acc_y + y}
    end)
    |> (fn {x, y} -> x * y end).()
  end
end

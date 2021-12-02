defmodule Aoc do
  @doc """
  ## Examples
    iex> Aoc.run("forward 5
    ...>          down 5
    ...>          forward 8
    ...>          up 3
    ...>          down 8
    ...>          forward 2")
    900
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
    |> Enum.reduce({0, 0, 0}, fn
      {0, aim}, {acc_x, acc_y, acc_a} -> {acc_x, acc_y, acc_a + aim}
      {move, 0}, {acc_x, acc_y, acc_a} -> {acc_x + move, acc_y + move * acc_a, acc_a}
    end)
    |> (fn {x, y, _} -> x * y end).()
  end
end

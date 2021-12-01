defmodule Aoc do
  @doc """
  ## Examples
    iex> Aoc.run("199
    ...>   200
    ...>   208
    ...>   210
    ...>   200
    ...>   207
    ...>   240
    ...>   269
    ...>   260
    ...>   263")
    7
  """
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(String.length(&1) > 0))
    |> Stream.map(&String.to_integer/1)
    |> Enum.reduce({0, nil}, fn
      x, {0, nil} -> {0, x}
      x, {acc, last} -> {(x > last && acc + 1) || acc, x}
    end)
    |> (fn {answer, _} -> answer end).()
    |> IO.inspect()
  end
end

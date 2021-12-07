defmodule Aoc do
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> clean()
    |> calc_costs()
    |> IO.inspect()
  end

  def clean(string) do
    string
    |> String.split(~r/[,\n]/, trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  def calc_costs(list) do
    Enum.min(list)..Enum.max(list)
    |> Stream.map(fn n ->
      Stream.map(list, fn num ->
        max(num, n) - min(num, n)
      end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end
end

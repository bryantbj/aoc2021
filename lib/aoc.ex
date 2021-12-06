defmodule Aoc do
  def run(input, days) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run(days)
  end

  def run(input, days) do
    input
    |> clean()
    |> calc_fish_population(days)
    |> IO.inspect()
  end

  def clean(input) do
    input
    |> String.split(~r/[,\n]/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def calc_fish_population(list, days) do
    countem(list, days)
    |> Map.values()
    |> Enum.sum()
  end

  def countem(list, days) do
    Enum.reduce(1..days, Enum.frequencies(list), fn _day, acc ->
      new_fish = Map.get(acc, 0)

      acc
      |> advance_fish()
      |> add_fish(new_fish)
    end)
  end

  def advance_fish(fish_counts) do
    Enum.map(fish_counts, fn
      {0, n} -> {6, n}
      {i, n} -> {i - 1, n}
    end)
    |> map_counts
  end

  def add_fish(map, nil), do: map
  def add_fish(map, 0), do: map
  def add_fish(map, count), do: Map.update(map, 8, count, &(&1 + count))

  def map_counts(list) do
    Enum.reduce(list, %{}, fn {k, v}, map ->
      Map.update(map, k, v, &(&1 + v))
    end)
  end
end

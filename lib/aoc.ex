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
    |> only_horizontal_and_vertical_and_45()
    |> Stream.map(&plot_line/1)
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_, count} -> count >= 2 end)
    |> length
    |> IO.inspect()
  end

  def clean(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.split(&1, " -> ", trim: true))
    |> Stream.map(&Enum.map(&1, fn s -> String.trim(s) end))
    |> Stream.map(&Enum.map(&1, fn s -> String.split(s, ",") end))
    |> Stream.map(&List.flatten/1)
    |> Stream.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  end

  def only_horizontal_and_vertical_and_45(list) do
    list
    |> Stream.filter(fn [x1, y1, x2, y2] ->
      x1 == x2 || y1 == y2 || abs(x1 - x2) == abs(y1 - y2)
    end)
  end

  # horizontal
  def plot_line([x, y1, x, y2]) do
    Enum.reduce(y1..y2, [], fn el, acc ->
      [{x, el} | acc]
    end)
  end

  # vertical
  def plot_line([x1, y, x2, y]) do
    Enum.reduce(x1..x2, [], fn el, acc ->
      [{el, y} | acc]
    end)
  end

  # diagonal
  def plot_line([x1, y1, x2, y2]) do
    Enum.zip(x1..x2, y1..y2)
  end
end

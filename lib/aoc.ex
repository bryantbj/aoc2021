defmodule Aoc do
  @doc """
  ## Examples

      iex> Aoc.run("00100
      ...>11110
      ...>10110
      ...>10111
      ...>10101
      ...>01111
      ...>00111
      ...>11100
      ...>10000
      ...>11001
      ...>00010
      ...>01010")
      230
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
    # Run these in parallel
    |> (fn input -> Stream.map(["o2", "co2"], &rating(input, gauge: &1)) end).()
    |> calculate_life_support_from_readings()
    |> IO.inspect()
  end

  def clean(string) do
    string
    |> String.split("\n", trim: true)
  end

  def rating(str_list, gauge: gauge) do
    len = Enum.at(str_list, 0) |> String.length()

    Util.stream_reduce(0..(len - 1), str_list, fn i, acc ->
      acc
      |> Stream.map(&String.at(&1, i))
      |> Enum.to_list()
      |> gauge(gauge)
      |> using_char_at_filter_list(i, acc)
    end)
    |> Enum.at(0)
  end

  @doc """
  Converts a binary number represented as a string
  to its integer representation

  ## Examples

      iex> Aoc.binary_to_integer("11")
      3

      iex> Aoc.binary_to_integer("1101")
      13

      iex> Aoc.binary_to_integer("1000001")
      65
  """
  def binary_to_integer(str) do
    str
    |> Integer.parse(2)
    |> (fn {x, _} -> x end).()
  end

  def gauge(list, "co2") do
    list
    |> Enum.frequencies()
    |> (&((&1["0"] <= &1["1"] && "0") || "1")).()
  end

  def gauge(list, "o2") do
    list
    |> Enum.frequencies()
    |> (&((&1["1"] >= &1["0"] && "1") || "0")).()
  end

  @doc """
  Returns a new list where each element
  has `char` at position `at`.
  """
  def using_char_at_filter_list(char, at, list) do
    Stream.filter(list, &(String.at(&1, at) == char))
    |> Enum.to_list()
  end

  @doc """
  Reduces `list` my multiplying elements together
  """
  def calculate_life_support_from_readings(list) when is_list(list) do
    list
    |> Enum.map(&binary_to_integer/1)
    |> Enum.reduce(1, &(&2 * &1))
  end

  def calculate_life_support_from_readings(not_list) do
    not_list
    |> Enum.to_list()
    |> calculate_life_support_from_readings()
  end
end

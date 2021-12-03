defmodule Aoc do
  def test_input() do
    "00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010"
  end

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
    198
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
    |> rebuild()
    |> calc_gamma()
    |> calc_epsilon()
    |> calc_power_consumption()
    |> IO.inspect()
  end

  def test_run() do
    run(test_input())
  end

  def clean(string) do
    string
    # get the intended length of each binary number
    |> String.split("\n")
    |> Enum.at(0)
    |> String.length()
    # send that along with the cleaned string
    |> (fn len -> {string, len} end).()
    |> (fn {str, len} -> {String.replace(str, ~r{\s+}, ""), len} end).()
  end

  # builds a series of binary numbers
  def rebuild({str, len}) do
    full_str_length = String.length(str)
    max_binary_str_length = div(full_str_length, len)

    # using the i'th position from the beginning of the string
    Stream.map(0..(len - 1), fn i ->
      # iterate through the entire string with math!
      #
      # Using `Stream.scan` here instead of `Enum.reduce` because
      # a huge list can make this take forever, unnecessarily.
      # Each string is independent of the other, so there's no
      # reason to do it sequentially. The binary number strings
      # can be built in parallel.
      Stream.scan(1..max_binary_str_length, String.at(str, i), fn j, s ->
        position_of_char_to_append = j * len + i

        # if there are more characters to append, do it
        # otherwise, just return the final result
        case position_of_char_to_append >= full_str_length do
          false -> s <> String.at(str, position_of_char_to_append)
          _ -> s
        end
      end)
    end)
    # scan emits iterative results. we only want the last one, which is the final result
    |> Stream.map(&(&1 |> Enum.to_list() |> Enum.reverse() |> hd))
    # each char
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    # sum to figure out whether 1 or 0 occurs more
    |> Stream.map(&[Enum.sum(&1), (Enum.sum(&1) / length(&1) > 0.5 && 1) || 0])
    |> Stream.map(&tl/1)
    |> Enum.to_list()
    # result should be a binary number
    |> List.flatten()
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

  def calc_gamma(list) do
    list
    |> Enum.join()
    |> binary_to_integer()
    |> (&{list, &1}).()
  end

  def calc_epsilon({list, gamma}) do
    list
    |> Enum.map(&((&1 == 0 && 1) || 0))
    |> Enum.join()
    |> binary_to_integer()
    |> (&{gamma, &1}).()
  end

  def calc_power_consumption({g, e}) do
    g * e
  end
end

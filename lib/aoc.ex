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
    |> decode()
    |> IO.inspect()
  end

  def clean(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.to_list()
  end

  def decode(list_of_strings) when is_list(list_of_strings) do
    Stream.map(list_of_strings, &decode/1)
    |> Stream.map(&Enum.join(&1, ""))
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def decode(string) do
    [segments, numbers] = String.split(string, ~r/\s+\|\s+/, trim: true)

    known =
      segments
      |> decode_known()
      |> find_and_put(segments, 3)
      |> find_and_put(segments, 6)
      |> find_and_put(segments, 9)
      |> find_and_put(segments, 0)
      |> find_and_put(segments, :top_1)
      |> find_and_put(segments, 2)
      |> find_and_put(segments, 5)

    numbers
    |> String.split(" ", trim: true)
    |> Stream.map(&String.graphemes/1)
    |> Util.stream_reduce([], fn chars, acc ->
      found =
        Enum.find_value(known, nil, fn {key, letters} ->
          is?(letters, chars) && key
        end)

      [found | acc]
    end)
    |> Enum.reverse()
  end

  @doc """

    ## Examples
      iex>Aoc.decode_known("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab")
      %{1 => ~w[a b], 4 => ~w[e a f b], 7 => ~w[d a b], 8 => ~w[a c e d g f b]}
  """
  def decode_known(list) do
    [{1, 2}, {4, 4}, {7, 3}, {8, 7}]
    |> Enum.reduce(%{}, find_known(list))
  end

  def find_known(string) when is_binary(string) do
    string
    |> String.split(" ", trim: true)
    |> find_known()
  end

  def find_known(list) when is_list(list) do
    fn {n, len}, map ->
      chars =
        list
        |> Enum.find(&(String.length(&1) == len))
        |> String.graphemes()

      Map.put(map, n, chars)
    end
  end

  def find_and_put(known, given, n) do
    num = find(known, given, n) |> List.flatten()
    Map.put(known, n, num)
  end

  def find(known, given, 3) do
    given
    |> has_length_of(5)
    |> include?(known[1])
  end

  def find(known, given, 9) do
    given
    |> has_length_of(6)
    |> include?(known[3])
    |> include?(known[4])
  end

  def find(known, given, 6) do
    given
    |> has_length_of(6)
    |> not_include?(known[1])
  end

  def find(known, given, 0) do
    given
    |> has_length_of(6)
    |> is_not?(known[9])
    |> is_not?(known[6])
  end

  def find(known, _given, :top_1) do
    Enum.filter(known[1], fn char ->
      !Enum.member?(known[6], char)
    end)
  end

  def find(known, given, 2) do
    given
    |> has_length_of(5)
    |> is_not?(known[3])
    |> include?(known[:top_1])
  end

  def find(known, given, 5) do
    given
    |> has_length_of(5)
    |> is_not?(known[3])
    |> is_not?(known[2])
  end

  def has_length_of(list, n) when is_list(list) do
    list
    |> Enum.filter(&has_length_of(&1, n))
  end

  def has_length_of(string, n) do
    Regex.scan(~r/\b\w{#{n}}\b/, string)
    |> List.flatten()
    |> Enum.map(&String.graphemes/1)
  end

  def include?([a | _] = list_of_nums, other) when is_list(a) do
    Enum.filter(list_of_nums, &include?(&1, other))
  end

  @doc """
    ## Examples
      iex>Aoc.include?(~w[a b c], ~w[b c])
      true

      iex>Aoc.include?(~w[a b c], ~w[d])
      false
  """
  def include?(num, other) do
    Enum.all?(other, &Enum.member?(num, &1))
  end

  def not_include?([a | _] = list_of_nums, other) when is_list(a) do
    Enum.filter(list_of_nums, &not_include?(&1, other))
  end

  @doc """
    ## Examples
      iex>Aoc.not_include?(~w[a b c], ~w[b c])
      false

      iex>Aoc.not_include?(~w[a b c], ~w[d])
      true
  """
  def not_include?(num, other) do
    !include?(num, other)
  end

  def is_not?([a | _] = list_of_nums, other) when is_list(a) do
    Enum.filter(list_of_nums, &is_not?(&1, other))
  end

  def is_not?(num, other) do
    [num, other]
    |> Enum.map(&Enum.sort/1)
    |> Enum.map(&Enum.join(&1, ""))
    |> (fn [a, b] -> a != b end).()
  end

  def is?(num, other), do: !is_not?(num, other)
end

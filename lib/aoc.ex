defmodule Aoc do
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> analyze()
    |> determine_lows()
    |> Enum.sum()
    # |> Enum.to_list()
    # |> hd()
    |> IO.inspect(charlists: :as_lists)
  end

  def analyze(input) do
    %{}
    |> put_line_length(input)
    |> join(input)
  end

  def put_line_length(map, input) do
    len = Regex.run(~r/\w+\b/, input) |> hd() |> String.length()

    Map.put(map, :length, len)
  end

  def join(map, input) do
    lines =
      Regex.scan(~r/\w+\b/, input)
      |> List.flatten()

    map
    |> Map.put(:list_size, length(lines))
    |> Map.put(:input, Enum.join(lines) |> String.graphemes() |> List.to_tuple())
  end

  def determine_lows(%{input: input} = map) do
    Util.stream_reduce(0..(tuple_size(input) - 1), [], fn i, acc ->
      [{position_value(i, input), determine_adjs(map, i)} | acc]
    end)
    |> Stream.filter(fn {i, list} ->
      list = Enum.map(list, &position_value(&1, input))
      Enum.all?(list, &(&1 > i))
    end)
    |> Stream.map(&(elem(&1, 0) + 1))
  end

  def determine_adjs(%{list_size: size, length: len}, i) do
    {posy, posx} = index_position(i, len)

    [
      posx > 0 && i - 1,
      posx < len - 1 && i + 1,
      posy > 0 && i - len,
      posy < size - 1 && i + len
    ]
    |> Enum.filter(&is_integer/1)
  end

  def index_position(i, size) do
    {div(i, size), rem(i, size)}
  end

  def position_value(i, input) do
    elem(input, i) |> String.to_integer()
  end

  def basin(to_work, worked) do
  end
end

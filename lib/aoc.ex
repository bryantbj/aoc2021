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
    |> IO.inspect()
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
    |> Map.put(:input, Enum.join(lines))
  end

  def determine_lows(%{input: input} = map) do
    positions =
      Util.stream_reduce(0..(String.length(input) - 1), [], fn i, acc ->
        [
          {position_to_value(i, input), determine_adjs(map, i)}
          | acc
        ]
      end)

    Stream.filter(positions, fn {i, list} ->
      Enum.all?(list, &(&1 > i))
    end)
    |> Stream.map(fn {i, _} -> i + 1 end)
  end

  def determine_adjs(%{list_size: size, length: len, input: input}, i) do
    {posy, posx} = index_position(i, len)

    [
      posx > 0 && i - 1,
      posx < len - 1 && i + 1,
      posy > 0 && i - len,
      posy < size - 1 && i + len
    ]
    |> Enum.reject(&(&1 == false || &1 == nil))
    |> Enum.map(&position_to_value(&1, input))
  end

  def index_position(i, size) do
    {div(i, size), rem(i, size)}
  end

  def position_to_value(i, input) do
    String.at(input, i)
    |> String.to_integer()
  end
end

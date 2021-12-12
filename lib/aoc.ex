defmodule Aoc do
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> String.split(~r/\s+/, trim: true)
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&scan_line/1)
    |> Stream.filter(& &1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def scan_line(chars) do
    chars
    |> Enum.reduce_while(
      [],
      fn
        char, [last | rest] = acc ->
          cond do
            char in '[{<(' ->
              {:cont, [char | acc]}

            pair(char) != last ->
              {:halt, char}

            true ->
              {:cont, rest}
          end

        char, [] ->
          {:cont, [char]}
      end
    )
    |> case do
      l when is_list(l) ->
        nil

      c ->
        char_points(c)
    end
  end

  def pair(char) do
    %{?] => ?[, ?} => ?{, ?) => ?(, ?> => ?<}[char]
  end

  def char_points(char) do
    %{?) => 3, ?] => 57, ?} => 1197, ?> => 25137}[char]
  end
end

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
    |> Stream.map(&score_remaining_pattern/1)
    |> Enum.sort()
    |> List.to_tuple()
    |> (fn tuple ->
          idx =
            (tuple_size(tuple) / 2)
            |> ceil
            |> (&(&1 - 1)).()

          elem(tuple, idx)
        end).()
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
              {:halt, nil}

            true ->
              {:cont, rest}
          end

        char, [] ->
          {:cont, [char]}
      end
    )
    |> case do
      l when is_list(l) ->
        Enum.map(l, &pair/1)

      _ ->
        nil
    end
  end

  def score_remaining_pattern(list) do
    list
    |> Enum.reduce(0, &(&2 * 5 + char_points(&1)))
  end

  def pair(char) do
    %{?( => ?), ?[ => ?], ?{ => ?}, ?< => ?>, ?) => ?(, ?] => ?[, ?} => ?{, ?> => ?<}[char]
  end

  def char_points(char) do
    %{?) => 1, ?] => 2, ?} => 3, ?> => 4}[char]
  end
end

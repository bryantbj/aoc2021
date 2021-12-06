defmodule Aoc do
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> String.split(~r/[,\n]/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> countem()
    |> IO.inspect()
  end

  def countem(list) do
    Util.stream_reduce(1..80, list, fn _day, list ->
      new_fish_count =
        case Enum.frequencies(list) do
          %{0 => n} -> n
          _ -> 0
        end

      list
      |> Enum.map(fn
        0 -> 6
        n -> n - 1
      end)
      |> Enum.concat(list_of_8s(new_fish_count))
    end)
    |> length
  end

  def list_of_8s(count) do
    case count do
      0 -> []
      n -> Enum.reduce(1..n, [], fn _, acc -> [8 | acc] end)
    end
  end
end

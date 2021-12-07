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
    |> minimum_cost()
    |> IO.inspect()
  end

  def clean(string) do
    string
    |> String.split(~r/[,\n]/, trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  def minimum_cost(list) do
    potential_cost_range(list)
    |> Stream.map(movement_costs(list))
    |> Enum.min()
  end

  def distance(n1) do
    fn n2 ->
      max(n1, n2) - min(n1, n2)
    end
  end

  def distance_cost(n) do
    (n == 0 && 0) || Enum.sum(1..n)
  end

  def movement_costs(list) do
    fn prospect ->
      Stream.map(list, distance(prospect))
      |> Stream.map(&distance_cost/1)
      |> Enum.sum()
    end
  end

  def potential_cost_range(list) do
    Enum.min(list)..Enum.max(list)
  end
end

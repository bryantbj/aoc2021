defmodule Aoc do
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> parse()
    |> Recursion.recur()
    |> IO.inspect()
  end

  def parse(input) do
    input
    |> String.split(~r/\s+/, trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [left, right] = String.split(line, "-")
      acc = Map.update(acc, left, [right], &[right | &1])

      if left == "start" or right == "end" do
        acc
      else
        Map.update(acc, right, [left], &[left | &1])
      end
    end)
  end

  def test() do
    run("""
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """)
  end
end

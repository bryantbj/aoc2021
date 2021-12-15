defmodule Aoc do
  def test() do
    run("""
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """)
  end

  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    input
    |> parse()
    |> recur(10)
    |> count()
    |> IO.inspect()
  end

  def parse(input) do
    [template | rules] = Regex.split(~r/\n+/, input, trim: true)

    rules =
      rules
      |> Stream.map(&Regex.split(~r/ -> /, &1, trim: true))
      |> Stream.map(fn [a, b] -> {a, b} end)
      |> Enum.into(%{})

    {template, rules}
  end

  def recur({str, rules}, times) do
    if times <= 0 do
      str
    else
      str
      |> String.graphemes()
      |> Enum.chunk_every(2, 1)
      |> Enum.map(&Enum.join/1)
      |> Enum.reduce("", fn pair, acc ->
        case rules do
          %{^pair => insert} ->
            [a, _b] = String.graphemes(pair)
            acc <> Enum.join([a, insert])

          _ ->
            acc <> pair
        end
      end)
      |> (&recur({&1, rules}, times - 1)).()
    end
  end

  def count(str) do
    freqs =
      str
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.sort_by(fn {_k, v} -> v end)

    {_letter, lowest} = hd(freqs)
    {_letter, highest} = hd(Enum.reverse(freqs))

    highest - lowest
  end
end

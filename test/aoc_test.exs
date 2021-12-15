defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "test run 1" do
    result =
      Aoc.run("""
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

    assert result == 1588
  end

  # @tag :skip
  test "runs with input" do
    IO.puts("THE REAL DEAL")
    Aoc.run()
  end
end

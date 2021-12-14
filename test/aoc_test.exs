defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "test run 1" do
    result =
      Aoc.run("""
      6,10
      0,14
      9,10
      0,3
      10,4
      4,11
      6,0
      6,12
      4,1
      0,13
      10,12
      3,4
      3,0
      8,4
      1,10
      2,14
      8,10
      9,0

      fold along y=7
      fold along x=5
      """)

    # assert result == 36
  end

  # @tag :skip
  test "runs with input" do
    IO.puts("THE REAL DEAL")
    Aoc.run()
  end
end

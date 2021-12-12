defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "runs with test input" do
    result = Aoc.run("2199943210
                      3987894921
                      9856789892
                      8767896789
                      9899965678")

    assert result == 1134
  end

  test "runs with input" do
    Aoc.run()
  end
end

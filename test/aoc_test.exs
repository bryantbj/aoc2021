defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "runs with test input" do
    result =
      Aoc.run("""
      5483143223
      2745854711
      5264556173
      6141336146
      6357385478
      4167524645
      2176841721
      6882881134
      4846848554
      5283751526
      """)

    assert result == 1656
  end

  test "runs with input" do
    Aoc.run()
  end
end

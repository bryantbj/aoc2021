defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "runs with test input" do
    result = Aoc.run("16,1,2,0,4,2,7,1,2,14")
    assert result == 168
  end

  test "runs with input" do
    Aoc.run()
  end
end

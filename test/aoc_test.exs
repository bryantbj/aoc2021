defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "runs with test input" do
    result = Aoc.run("3,4,3,1,2")

    assert result == 5934
  end

  test "runs with input" do
    Aoc.run()
  end
end

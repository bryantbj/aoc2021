defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "runs with test input" do
    result = Aoc.run("[({(<(())[]>[[{[]{<()<>>
                      [(()[<>])]({[<{<<[]>>(
                      {([(<{}[<>[]}>{[]{[(<()>
                      (((({<>}<{<{<>}{[]{[]{}
                      [[<[([]))<([[{}[[()]]]
                      [{[{({}]{}}([{[{{{}}([]
                      {<[[]]>}<{[{[{[]{()[[[]
                      [<(<(<(<{}))><([]([]()
                      <{([([[(<>()){}]>(<<{{
                      <{([{{}}[<[[[<>{}]]]>[]]")

    assert result == 288_957
  end

  test "runs with input" do
    Aoc.run()
  end
end

defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "test run 1" do
    result =
      Aoc.run("""
      start-A
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
      """)

    assert result == 10
  end

  test "test run 2" do
    result =
      Aoc.run("""
      dc-end
      HN-start
      start-kj
      dc-start
      dc-HN
      LN-dc
      HN-end
      kj-sa
      kj-HN
      kj-dc
      """)

    assert result == 19
  end

  test "test run 3" do
    result =
      Aoc.run("""
      fs-end
      he-DX
      fs-he
      start-DX
      pj-DX
      end-zg
      zg-sl
      zg-pj
      pj-he
      RW-he
      fs-DX
      pj-RW
      zg-RW
      start-pj
      he-WI
      zg-he
      pj-fs
      start-RW
      """)

    assert result == 226
  end

  test "runs with input" do
    IO.puts("THE REAL DEAL")
    Aoc.run()
  end
end

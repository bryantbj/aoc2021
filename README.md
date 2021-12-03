# Aoc

This repo tracks my progress in the 2021 [AdventOfCode](https://adventofcode.com/2021)

Each challenge will be solved using Elixir.

Once a solution is reached, a branch is created in the format of `<day>-<part>-complete`, e.g. `01-a-complete`.

The file structure is:

- `priv/input.txt` - this is the AOC-provided input for the challenge
- `lib/aoc.ex` - this is the main program file, containing the main entry point of `Aoc.run()`
- `test/aoc_test.exs` - runs the entry point with the full input file; contains any other tests that can't be presented as doctests.

On each branch, the files will all be as they were at the time of completion - i.e., `priv/input.txt` on `01-a-complete` will be the input from day 1, etc.

Thanks for stopping by and enjoy! 🍻

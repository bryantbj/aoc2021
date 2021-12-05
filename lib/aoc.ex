defmodule Aoc do
  @doc """
  ## Examples

      iex> Aoc.run("7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
      ...>
      ...>22 13 17 11  0
      ...>8  2 23  4 24
      ...>21  9 14 16  7
      ...>6 10  3 18  5
      ...>1 12 20 15 19
      ...>
      ...>3 15  0  2 22
      ...>9 18 13 17  5
      ...>19  8  7 25 23
      ...>20 11 10 24  4
      ...>14 21 16 12  6
      ...>
      ...>14 21 17 24  4
      ...>10 16 15  9 19
      ...>18  8 23 26 20
      ...>22 11 13  6  5
      ...>2  0 12  3  7")
      4512
  """
  def run(input \\ nil)

  def run(input) when is_nil(input) do
    Path.expand("../priv/input.txt", __DIR__)
    |> File.read!()
    |> run()
  end

  def run(input) do
    game = build_game(input)

    game
    |> draw_until_win()
    |> find_winner()
    |> score_card(game)
    |> IO.inspect()
  end

  def test_run() do
    run(input_test())
  end

  def input_test() do
    "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
    8  2 23  4 24
    21  9 14 16  7
    6 10  3 18  5
    1 12 20 15 19

    3 15  0  2 22
    9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
    2  0 12  3  7"
  end

  def build_game(string) do
    [draws | boards] = String.split(string, "\n\n", trim: true)
    boards = build_board(boards)

    draws = Regex.scan(~r/\d+/, draws) |> List.flatten()

    %{:draws => draws, :boards => boards}
  end

  def build_board(boards) when is_list(boards) do
    boards
    |> Stream.map(&build_board/1)
    |> Enum.to_list()
  end

  def build_board(board) do
    board
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.scan(~r/\d+\b/, &1))
    |> Enum.to_list()
    |> List.flatten()
  end

  def draw(num, board) do
    idx = Enum.find_index(board, &(&1 == num))
    board = (idx && List.replace_at(board, idx, ".")) || board

    case idx do
      nil -> {board, {0, 0}}
      _ -> {board, place_makes_win?(idx, board)}
    end
  end

  def draw_until_win(game) do
    Util.stream_reduce(game.boards, [], fn board, acc ->
      Enum.reduce_while(game.draws, board, fn num, acc_board ->
        draw_result = draw(num, acc_board)

        case draw_result do
          {board, {1, _}} -> {:halt, {Enum.find_index(game.draws, &(&1 == num)), board}}
          {board, {_, 1}} -> {:halt, {Enum.find_index(game.draws, &(&1 == num)), board}}
          {board, _} -> {:cont, board}
        end
      end)
      |> (&[&1 | acc]).()
    end)
  end

  # The given place `n` is a win if all
  # the the spots in `n`'s row or column
  # are marked.
  def place_makes_win?(n, board) do
    row_win =
      board
      |> Enum.slice(div(n, 5) * 5, 5)
      |> Enum.all?(&(&1 == "."))
      |> (&((&1 && 1) || 0)).()

    col_win =
      Util.stream_reduce(0..4, [], fn row, acc ->
        [Enum.at(board, row * 5 + rem(n, 5)) | acc]
      end)
      |> Enum.all?(&(&1 == "."))
      |> (&((&1 && 1) || 0)).()

    {row_win, col_win}
  end

  def find_winner(results) do
    results
    |> Stream.map(&Tuple.to_list/1)
    |> Enum.sort_by(&Enum.at(&1, 0))
    |> hd
  end

  def score_card([idx, board], %{draws: draws}) do
    unmarked =
      board
      |> Enum.filter(&(&1 != "."))
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    Enum.at(draws, idx)
    |> String.to_integer()
    |> (&(&1 * unmarked)).()
  end
end

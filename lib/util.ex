defmodule Util do
  @doc """
  Uses `Stream.scan` to reduce `enum` enumerable using
  `acc` accumulator and `function` reducer, but returns
  the result that `Enum.reduce` would return.

  Useful for reducing large enumerables.

  ## Examples

      iex> Util.stream_reduce(1..10, "", & &2 <> Integer.to_string(&1))
      "12345678910"

  """
  # Use Stream.scan, but get the same result
  # as using Enum.reduce
  def stream_reduce(enum, acc, function) do
    enum
    |> Stream.scan(acc, function)
    |> Enum.reverse()
    |> hd
  end
end

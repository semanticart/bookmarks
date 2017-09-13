defmodule BookmarksData.SortedSetType do
  @moduledoc """
  An Ecto.Type implementation that enforces an array column that acts like a
  sorted set of strings (sorted and no duplicate entries).
  """

  @behaviour Ecto.Type
  def type, do: {:array, :string}

  def cast(nil), do: {:ok, []}
  def cast(arr) when is_list(arr) do
    if Enum.all?(arr, &String.valid?/1) do
      {:ok, arr |> Enum.sort |> Enum.uniq}
    else
      :error
    end
  end
  def cast(str) when is_binary(str), do: cast(String.split(str, ","))
  def cast(_), do: :error

  def dump(val) when is_list(val), do: {:ok, val}
  def dump(_), do: :error
  def load(val) when is_list(val), do: {:ok, val}
  def load(_), do: :error
end

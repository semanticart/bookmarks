defmodule BookmarksData.SortedSetTypeTest do
  use ExUnit.Case, async: true
  doctest BookmarksData.SortedSetType

  test "casting converts nil to an empty array" do
    assert BookmarksData.SortedSetType.cast(nil) == {:ok, []}
  end

  test "casting de-dupes and sorts array input" do
    unsorted_with_dupes = ["z", "x", "y", "x", "x"]
    sorted_and_deduped = ["x", "y", "z"]

    assert BookmarksData.SortedSetType.cast(unsorted_with_dupes) ==
      {:ok, sorted_and_deduped}
  end

  test "casting comma-separated string input" do
    unsorted_with_dupes = "z,x,y,x,x,x"
    sorted_and_deduped = ["x", "y", "z"]

    assert BookmarksData.SortedSetType.cast(unsorted_with_dupes) ==
      {:ok, sorted_and_deduped}
  end

  test "casting non-strings returns an error" do
    assert BookmarksData.SortedSetType.cast([1, "hi"]) == :error
  end
end

defmodule BookmarksCLITest do
  use ExUnit.Case, async: true
  doctest BookmarksCLI

  import ExUnit.CaptureIO
  alias BookmarksData.Fixtures

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BookmarksData.Repo)
  end

  test "it can list all bookmarks" do
    {:ok, vim} = BookmarksData.insert(Fixtures.vim_attributes)
    {:ok, learning} = BookmarksData.insert(Fixtures.learning_attributes)

    assert_output main([]), [vim, learning]
  end

  test "it can add a uri with tags" do
    uri = "https://twitter.com"

    output = main([uri, "social", "news", "timesink"])

    inserted = BookmarksData.get_by(uri: uri)
    # sorted
    assert inserted.tags == ["news", "social", "timesink"]

    assert_output output, inserted
  end

  test "it can add a uri with tags and a description" do
    uri = "https://twitter.com"

    output = main([uri, "social", "news", "timesink", "-d", "ye olde IM status"])

    inserted = BookmarksData.get_by(uri: uri)
    assert inserted.tags == ["news", "social", "timesink"]
    assert inserted.description == "ye olde IM status"

    assert_output output, inserted
  end

  test "it can find bookmarks by tags" do
    {:ok, vim} = BookmarksData.insert(Fixtures.vim_attributes)
    {:ok, learning} = BookmarksData.insert(Fixtures.learning_attributes)

    assert_output(main(["read"]), [vim, learning])
    assert_output(main(learning.tags), [learning])
  end

  test "it can add to a bookmark's tags by id" do
    {:ok, original} = BookmarksData.insert(Fixtures.vim_attributes)
    assert original.tags == ["read", "vim"]

    output = main(["--tag", original.id, "semanticart", "mine"])

    updated = BookmarksData.get_by(id: original.id)
    assert updated.tags == ["mine", "read", "semanticart", "vim"]

    assert_output(output, updated)
  end

  test "it can remove from a bookmark's tags by id" do
    {:ok, original} = BookmarksData.insert(Fixtures.vim_attributes)
    assert original.tags == ["read", "vim"]

    # remove an actual tag and ignore one that wasn't present
    output = main(["--untag", original.id, "read", "mine"])

    updated = BookmarksData.get_by(id: original.id)
    assert updated.tags == ["vim"]

    assert_output(output, updated)
  end

  test "it can mark a bookmark read by id" do
    {:ok, original} = BookmarksData.insert(Fixtures.vim_attributes)
    assert original.tags == ["read", "vim"]

    output = main(["--markread", original.id])

    updated = BookmarksData.get_by(id: original.id)
    assert updated.tags == ["vim"]

    assert_output(output, updated)
  end

  test "it can display a bookmark's source text by id" do
    {:ok, inserted} = BookmarksData.insert(Fixtures.vim_attributes)
    output = main(["--read", inserted.id])

    assert output == File.read!("#{__DIR__}/fixtures/vim.txt")
  end

  defp main(args) do
    capture_io(fn ->
      BookmarksCLI.main(args)
    end)
  end

  defp assert_output(actual, comparable) do
    expected = comparable
               |> BookmarksCLI.format
               |> IO.iodata_to_binary
               |> String.trim

    assert String.trim(actual) == expected
  end
end

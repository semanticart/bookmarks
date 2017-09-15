defmodule BookmarksDataTest do
  use ExUnit.Case, async: true
  doctest BookmarksData

  alias BookmarksData.Fixtures

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BookmarksData.Repo)
  end

  test "listing all bookmarks" do
    {:ok, vim} = BookmarksData.insert(Fixtures.vim_attributes)
    {:ok, learning} = BookmarksData.insert(Fixtures.learning_attributes)

    assert BookmarksData.all() == [vim, learning]
  end

  test "inserting a bookmark" do
    new_bookmark = Fixtures.vim
    attributes_without_title = Map.merge(Fixtures.vim_attributes, %{title: nil})
    {:ok, inserted} = BookmarksData.insert(attributes_without_title)

    # provided
    assert inserted.uri == new_bookmark.uri
    assert inserted.description == new_bookmark.description
    assert inserted.tags == Enum.sort(new_bookmark.tags)

    # fetched
    assert inserted.data == Fixtures.vim_html
    assert inserted.title == "Let's write a basic Vim plugin | semantic art"
  end

  test "failing to insert an invalid bookmark" do
    invalid_attributes = Map.merge(Fixtures.learning_attributes, %{title: nil, uri: "cats"})
    {:error, changeset} = BookmarksData.insert(invalid_attributes)

    assert [
      title: {"can't be blank", [validation: :required]},
      uri: {"is invalid", [uri: URI.parse(invalid_attributes.uri)]},
    ] == changeset.errors
  end

  test "updating a bookmark" do
    {:ok, original} = BookmarksData.insert(Fixtures.vim_attributes)

    {:ok, updated} = BookmarksData.update(original, %{title: "New", description: "..."})

    # Unchanged
    assert updated.id == original.id
    assert updated.uri == original.uri
    assert updated.tags == original.tags

    # Updated
    assert updated.title == "New"
    assert updated.description == "..."
  end

  test "failing to update an invalid bookmark" do
    {:ok, original} = BookmarksData.insert(Fixtures.vim_attributes)
    {:error, changeset} = BookmarksData.update(original, %{uri: nil})

    assert [uri: {"can't be blank", [validation: :required]}] == changeset.errors
  end

  test "marking a bookmark as read" do
    {:ok, original} = BookmarksData.insert(Fixtures.vim_attributes)
    assert original.tags == ["read", "vim"]

    {:ok, updated} = BookmarksData.mark_read(original)
    assert updated.tags == ["vim"]
  end

  test "finding by tag" do
    {:ok, vim} = BookmarksData.insert(Fixtures.vim_attributes)
    {:ok, _} = BookmarksData.insert(Fixtures.learning_attributes)

    assert BookmarksData.tagged(vim.tags) == [vim]
  end

  test "finding by tags" do
    {:ok, vim} = BookmarksData.insert(Fixtures.vim_attributes)
    {:ok, learning} = BookmarksData.insert(Fixtures.learning_attributes)

    assert BookmarksData.tagged(["read"]) == [vim, learning]
    assert BookmarksData.tagged(learning.tags) == [learning]
  end

  test "finding by uri" do
    uri = Fixtures.vim_attributes.uri
    assert nil == BookmarksData.get_by(uri: uri)

    {:ok, vim} = BookmarksData.insert(Fixtures.vim_attributes)

    assert vim == BookmarksData.get_by(uri: uri)
  end
end

defmodule BookmarksData.BookmarkTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset, only: [get_field: 2]
  alias BookmarksData.Fixtures

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BookmarksData.Repo)
  end

  test "a changeset for a new bookmark fetches the title and source data" do
    new_bookmark = Fixtures.vim
    attributes_without_title = Map.merge(Fixtures.vim_attributes, %{title: nil})
    changeset = BookmarksData.Bookmark.changeset(attributes_without_title)

    # provided
    assert get_field(changeset, :uri) == new_bookmark.uri
    assert get_field(changeset, :description) == new_bookmark.description
    assert get_field(changeset, :tags) == Enum.sort(new_bookmark.tags)

    # fetched
    assert get_field(changeset, :data) == Fixtures.vim_html
    assert get_field(changeset, :title) == "Let's write a basic Vim plugin | semantic art"
  end

  test "a changeset sorts and de-dupes tags" do
    unsorted = ["z", "x", "y", "x"]
    attrs = Map.merge(Fixtures.vim_attributes, %{tags: unsorted})
    changeset = BookmarksData.Bookmark.changeset(attrs)

    assert get_field(changeset, :tags) == ["x", "y", "z"]
  end

  test "changeset validates title and uri" do
    invalid_attributes = Map.merge(Fixtures.learning_attributes, %{title: nil, uri: "cats"})
    changeset = BookmarksData.Bookmark.changeset(invalid_attributes)

    assert [
      title: {"can't be blank", [validation: :required]},
      uri: {"is invalid", [uri: URI.parse(invalid_attributes.uri)]},
    ] == changeset.errors
  end

  test "changeset validates uri uniqueness" do
    {:ok, _} = BookmarksData.DB.insert(Fixtures.vim_attributes)
    changeset = BookmarksData.Bookmark.changeset(Fixtures.vim_attributes)

    assert [
      uri: {"has already been taken", [validation: :unsafe_unique, fields: [:uri]]}
    ] == changeset.errors
  end
end

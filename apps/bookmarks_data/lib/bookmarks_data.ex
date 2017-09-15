defmodule BookmarksData do
  alias BookmarksData.Repo
  import Ecto.Query, only: [from: 2]

  def insert(attributes) do
    %BookmarksData.Bookmark{}
    |> BookmarksData.Bookmark.changeset(attributes)
    |> Repo.insert
  end

  def update(bookmark = %BookmarksData.Bookmark{}, changes) do
    bookmark
    |> BookmarksData.Bookmark.changeset(changes)
    |> Repo.update
  end

  def mark_read(bookmark = %BookmarksData.Bookmark{}) do
    new_tags = bookmark.tags
               |> Enum.reject(fn tag -> tag == "read" end)

    update(bookmark, %{tags: new_tags})
  end

  def tagged(tags) when is_list(tags) do
    query = from b in BookmarksData.Bookmark,
      where: fragment("tags @> ?", ^tags),
      order_by: [asc: :id]

    Repo.all(query)
  end
  def tagged(tag) do
    tagged([tag])
  end

  def get_by(map) do
    Repo.get_by(BookmarksData.Bookmark, map)
  end

  def all do
    query = from b in BookmarksData.Bookmark,
      order_by: [asc: :id]

    Repo.all(query)
  end
end

defmodule BookmarksCLI do
  def main([]), do: all()
  def main(args = [head | tail]) do
    if BookmarksData.URIValidator.valid?(head) do
      insert(head, tail)
    else
      OptionParser.parse(args,
                         switches: [
                           markread: :boolean,
                           read: :boolean,
                           tag: :boolean,
                           untag: :boolean,
                         ],
                         aliases: [
                           r: :read,
                           mr: :markread,
                           t: :tag,
                           ut: :untag,
                         ])
                         |> action
    end
  end

  defp insert(uri, opts) when is_list(opts) do
    opts = OptionParser.parse(opts,
                              switches: [
                                description: :string,
                                title: :string,
                              ],
                              aliases: [
                                d: :description,
                                t: :title,
                              ])

    insert(uri, opts)
  end
  defp insert(uri, {parsed, tags, []}) do
    parsed = Enum.into(parsed, %{})
    attributes = Map.merge(parsed, %{uri: uri, tags: Enum.sort(tags)})

    {:ok, bookmark} = BookmarksData.insert(attributes)

    bookmark
    |> format
    |> IO.puts
  end

  defp action({[read: true], [id], []}) do
    BookmarksData.get_by(id: id).data
    |> Readability.article
    |> Readability.readable_text
    |> IO.puts
  end
  defp action({[markread: true], [id], []}) do
    bookmark = BookmarksData.get_by(id: id)
    {:ok, updated} = BookmarksData.mark_read(bookmark)

    updated
    |> format
    |> IO.puts
  end
  defp action({[tag: true], [id | tags], []}) do
    bookmark = BookmarksData.get_by(id: id)
    {:ok, updated} = BookmarksData.update(bookmark, %{tags: bookmark.tags ++ tags})

    updated
    |> format
    |> IO.puts
  end
  defp action({[untag: true], [id | tags], []}) do
    bookmark = BookmarksData.get_by(id: id)
    {:ok, updated} = BookmarksData.update(bookmark, %{tags: bookmark.tags -- tags})

    updated
    |> format
    |> IO.puts
  end
  defp action({[], tags, []}) do
    tags
    |> BookmarksData.tagged
    |> format
    |> IO.puts
  end

  def all do
    BookmarksData.all
    |> format
    |> IO.puts
  end

  def format(bookmarks) when is_list(bookmarks) do
    bookmarks
    |> BookmarksCLI.Formatter.format
    |> IO.ANSI.format
  end
  def format(bookmark) do
    format([bookmark])
  end
end

defmodule BookmarksCLI.Formatter do
  alias BookmarksData.Bookmark

  @moduledoc """
  CLI formatting for bookmarks
  """

  @doc """
  Format a single bookmark w/ ANSI color ready for piping to IO.ANSI.format |> IO.puts
  """
  def format(bookmark = %Bookmark{}) do
    format(bookmark, padding_for_index(bookmark.id), bookmark.id)
  end

  @doc """
  Format an array of bookmarks w/ ANSI color ready for piping to IO.ANSI.format |> IO.puts
  """
  def format(bookmarks) when is_list(bookmarks) do
    max_id = Enum.max_by(bookmarks, fn bookmark -> bookmark.id end).id
    padding = padding_for_index(max_id)

    bookmarks
    |> Enum.map(fn bookmark = %Bookmark{} ->
      format(bookmark, padding, bookmark.id)
    end)
  end

  def format(bookmark = %Bookmark{}, padding, index) do
    [
      format_index(index, padding),
      format_title(bookmark.title),
      prefixed(">", bookmark.uri, padding),
      prefixed("+", bookmark.description, padding),
      prefixed("#", Enum.join(bookmark.tags, ","), padding)
    ]
  end

  defp padding_for_index(index) do
    number_width(index) + 3
  end

  defp number_width(number) do
    number
    |> Integer.to_string
    |> String.length
  end

  defp format_index(index, padding) do
    [
      :bright,
      :cyan,
      Integer.to_string(index),
      String.pad_trailing(".", padding - number_width(index) - 1),
    ]
  end

  defp format_title(title) do
    [
      :bright,
      :light_green,
      title,
      "\n",
      :reset,
    ]
  end

  defp prefixed(_prefix, nil, _padding), do: []
  defp prefixed(prefix, content, padding) do
    [
      :bright,
      :red,
      String.pad_leading(prefix, padding),
      " ",
      :reset,
      content,
      "\n",
    ]
  end
end

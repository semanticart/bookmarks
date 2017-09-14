defmodule BookmarksCLI.FormatterTest do
  use ExUnit.Case, async: true
  doctest BookmarksCLI.Formatter

  alias BookmarksCLI.Formatter

  @vim Map.merge(BookmarksData.Fixtures.vim, %{description: nil, id: 1})
  @vim_with_description Map.merge(@vim, %{description: "Looks pretty simple."})
  @learning Map.merge(BookmarksData.Fixtures.learning, %{id: 2})

  test "format w/ no description" do
    expected = [
      [:bright, :cyan, "1", ". "],
      [:bright, :light_green, @vim.title, "\n", :reset],
      [:bright, :red, "   >", " ", :reset, @vim.uri, "\n"],
      [],
      [:bright, :red, "   #", " ", :reset, format_tags(@vim), "\n"]
    ]

    assert expected == Formatter.format(@vim)
  end

  test "format w/ a description" do
    bookmark = @vim_with_description

    expected = [
      [:bright, :cyan, "1", ". "],
      [:bright, :light_green, bookmark.title, "\n", :reset],
      [:bright, :red, "   >", " ", :reset, bookmark.uri, "\n"],
      [:bright, :red, "   +", " ", :reset, bookmark.description, "\n"],
      [:bright, :red, "   #",  " ", :reset, format_tags(bookmark), "\n"]
    ]

    assert expected == Formatter.format(bookmark)
  end

  test "format w/ padding" do
    bookmark = @vim

    expected = [
      [:bright, :cyan, "123456", ". "],
      [:bright, :light_green, bookmark.title, "\n", :reset],
      [:bright, :red, "        >", " ", :reset, bookmark.uri, "\n"],
      [],
      [:bright, :red, "        #", " ", :reset, format_tags(bookmark), "\n"]
    ]

    bookmark = %{bookmark | id: 123456}

    assert expected == Formatter.format(bookmark)
  end

  test "format with an array" do
    expected = [
      Formatter.format(@vim_with_description),
      Formatter.format(@learning),
    ]

    books = [@vim_with_description, @learning]
    assert expected == Formatter.format(books)
  end

  def format_tags(bookmark) do
    Enum.join(bookmark.tags, ",")
  end
end

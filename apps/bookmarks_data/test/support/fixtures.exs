defmodule BookmarksData.Fixtures do
  def vim_attributes do
    %{
      title: "Let's Write a Basic Vim Plugin",
      uri: "http://blog.semanticart.com/blog/2017/01/05/lets-write-a-basic-vim-plugin/",
      description: "I wrote this",
      tags: ["vim", "read"]
    }
  end

  def vim do
    Map.merge(%BookmarksData.Bookmark{}, vim_attributes())
  end

  def vim_html do
    File.read!("test/fixtures/vim.html")
  end

  def learning_attributes do
    %{
      title: "Learning Resources - Elixir",
      uri: "https://elixir-lang.org/learning.html",
      description: nil,
      tags: ["elixir", "read"],
    }
  end

  def learning do
    Map.merge(%BookmarksData.Bookmark{}, learning_attributes())
  end
end

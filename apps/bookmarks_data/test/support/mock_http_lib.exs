defmodule BookmarksData.MockHTTPLib do
  def get("http://blog.semanticart.com/blog/2017/01/05/lets-write-a-basic-vim-plugin/") do
    {:ok, File.read!("test/fixtures/vim.html")}
  end
  def get("https://twitter.com") do
    simple_response("Twitter")
  end
  def get("https://elixir-lang.org/learning.html") do
    simple_response("Elixir learning...")
  end
  def get(uri), do: throw(uri)

  def simple_response(title) do
    {:ok, "<html><head><title>#{title}</title></head></html>"}
  end
end

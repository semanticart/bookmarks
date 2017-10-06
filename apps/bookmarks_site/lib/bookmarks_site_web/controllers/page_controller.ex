defmodule BookmarksSiteWeb.PageController do
  use BookmarksSiteWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:bookmarks, BookmarksData.all)
    |> render("index.html")
  end

  def tag(conn, %{"tag" => tag}) do
    conn
    |> assign(:name, "Bookmarks tagged #{tag}")
    |> assign(:bookmarks, BookmarksData.tagged(tag))
    |> render("index.html")
  end
end

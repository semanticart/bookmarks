defmodule BookmarksSiteWeb.PageView do
  use BookmarksSiteWeb, :view

  def page_title(conn) do
    conn.assigns
    |> Map.get(:name) || "Bookmarks"
  end
end

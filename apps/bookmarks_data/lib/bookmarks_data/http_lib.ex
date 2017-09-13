defmodule BookmarksData.HTTPLib do
  @options [
    follow_redirect: true,
    max_redirect: 10,
  ]

  @user_agent "Bookmark Manager"

  def get(nil), do: {:ok, nil}
  def get(uri) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} =
      HTTPoison.get(uri, [{"User-Agent", @user_agent}], @options)

    {:ok, body}
  end
end

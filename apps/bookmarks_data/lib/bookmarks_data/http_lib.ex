defmodule BookmarksData.HTTPLib do
  @options [
    follow_redirect: true,
    max_redirect: 10,
  ]

  @user_agent "Bookmark Manager"

  def get(nil), do: {:ok, nil}
  def get(uri) do
    {:ok, response = %HTTPoison.Response{status_code: 200}} =
      HTTPoison.get(uri, [{"User-Agent", @user_agent}], @options)

    {:ok, extract_body(response)}
  end

  # via https://github.com/edgurgel/httpoison/issues/81
  defp extract_body(response) do
    gzipped = Enum.any?(response.headers, fn (kv) ->
      case kv do
        {"Content-Encoding", "gzip"} -> true
        {"Content-Encoding", "x-gzip"} -> true
        _ -> false
      end
    end)

    # return an Elixir string
    if gzipped do
      :zlib.gunzip(response.body)
    else
      response.body
    end
  end
end

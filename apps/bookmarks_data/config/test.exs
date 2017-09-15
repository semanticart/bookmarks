use Mix.Config

config :bookmarks_data, BookmarksData.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "bookmarks_test",
  ownership_timeout: :infinity, # don't timeout during debugging
  loggers: []

# prevent warning "module BookmarksData.MockHTTPLib is not available"
Code.require_file "../test/support/mock_http_lib.exs", __DIR__

config :bookmarks_data, :http_lib,
  BookmarksData.MockHTTPLib

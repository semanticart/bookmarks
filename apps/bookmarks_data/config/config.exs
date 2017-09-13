# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :bookmarks_data, BookmarksData.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bookmarks",
  username: System.get_env("PG_USERNAME") || "postgres",
  password: System.get_env("PG_PASSWORD") || "postgres",
  hostname: System.get_env("PG_HOSTNAME") || "localhost",
  port: System.get_env("PG_PORT") || "5432"

config :bookmarks_data,
  ecto_repos: [BookmarksData.Repo],
  http_lib: BookmarksData.HTTPLib

import_config "#{Mix.env}.exs"

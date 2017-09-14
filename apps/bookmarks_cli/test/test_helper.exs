ExUnit.start()

Code.require_file "support/fixtures.exs", "#{__DIR__}../../../bookmarks_data/test"

Ecto.Adapters.SQL.Sandbox.mode(BookmarksData.Repo, :manual)

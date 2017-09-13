defmodule BookmarksData.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bookmarks_data,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BookmarksData.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:floki, "~> 0.14"},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
    ]
  end
end

defmodule BookmarksCli.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bookmarks_cli,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: escript(),
    ]
  end

  def escript do
    [main_module: BookmarksCLI]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bookmarks_data, in_umbrella: true},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:readability, "~> 0.7"},
    ]
  end
end

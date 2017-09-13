defmodule Bookmarks.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
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

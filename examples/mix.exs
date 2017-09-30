defmodule Examples.Mixfile do
  use Mix.Project

  def project do
    [
      app: :examples,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison, :timex],
      extra_applications: [:logger],
      mod: {Examples.Application, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.12"},
      {:slime, "~> 1.0.0"},
      {:timex, "~> 3.1"},
      {:topo, "~> 0.1.2"},
    ]
  end
end

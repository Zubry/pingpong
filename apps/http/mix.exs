defmodule HTTP.MixProject do
  use Mix.Project

  def project do
    [
      app: :http,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :corsica],
      mod: {HTTP.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"}, # This will pull in Plug AND Cowboy
      {:poison, "~> 3.1"},
      {:corsica, "~> 1.0"},
      {:game_graph, in_umbrella: true},
      {:elo, in_umbrella: true}
    ]
  end
end

defmodule ExquiLive.MixProject do
  use Mix.Project

  def project do
    [
      app: :exqui_live,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExquiLive.Application, []}
    ]
  end

  defp aliases do
    [
      "assets.deploy": [
        "cmd --cd assets npm run deploy",
        "esbuild default --minify"
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exq, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.16"},
      {:phoenix_html, "~> 3.0.4"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:plug_cowboy, "~> 2.5.2", only: :dev},
      {:jason, "~> 1.2.2", only: [:dev, :test, :docs]},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:floki, ">= 0.30.0", only: :test}
    ]
  end
end

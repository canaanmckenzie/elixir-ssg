defmodule QuantNotes.MixProject do
  use Mix.Project

  def project do
    [
      app: :quant_notes,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

#create a mix alias
 defp aliases() do
    [
      "site.build": ["build","tailwind default --minify","esbuild default --minify"]
    ]
 end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_publisher, "~> 0.1.3"},
      {:makeup_elixir, ">= 0.0.0"},
      {:makeup_erlang, ">= 0.0.0"},
      {:phoenix_live_view, "~>0.18.12"},
      {:esbuild, "~> 0.5"},
      {:tailwind, "~>0.1.8"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

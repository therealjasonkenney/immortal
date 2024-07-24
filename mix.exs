defmodule Immortal.MixProject do
  alias Immortal.Mailer
  use Mix.Project

  def project do
    [
      app: :immortal,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: framework() ++ deps() ++ tools(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Immortal.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  # (outside the default ones (framework) or dev tools.
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:guardian, "~> 2.3"}
    ]
  end

  # Dev and CI tools.
  defp tools do
    [
      # Static analysis.
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      # Test coverage.
      {:excoveralls, "~> 0.18", only: :test},
      # Reload phoenix after changing code w/o restart.
      {:phoenix_live_reload, "~> 1.2", only: :dev}
    ]
  end

  # Changing these dependencies would
  # require some refactoring as Phoenix hooks everything
  # up with these in mind.
  defp framework do
    [
      # Phoenix Framework
      # lib/immortal/application.ex
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},

      # Phoenix Web
      # lib/immortal_web.ex
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.0.0-rc.1", override: true},

      # Telemetry
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},

      # Localization
      {:gettext, "~> 0.20"},

      # JSON parser/encoder
      {:jason, "~> 1.2"},

      # Database
      {:postgrex, ">= 0.0.0"},

      # Node discovery
      {:dns_cluster, "~> 0.1.1"},

      # HTTP Server
      {:bandit, "~> 1.5"},

      # Mailer
      {:swoosh, "~> 1.5"},

      # HTTP Client for Mailer.
      {:finch, "~> 0.13"},

      # JS compilation.
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},

      # Tailwind CSS Framework
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},

      # HTML node searching for tests.
      {:floki, ">= 0.30.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind immortal", "esbuild immortal"],
      "assets.deploy": [
        "tailwind immortal --minify",
        "esbuild immortal --minify",
        "phx.digest"
      ]
    ]
  end
end

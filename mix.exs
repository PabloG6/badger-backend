defmodule BadgerApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :badger_api,
      releases: [
        badger_api: [
          include_erts: true,
          include_exectuables_for: [:unix],
          applications: [
            runtime_tools: :permanent
          ],
          version: "0.0.1"
        ]
      ],
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BadgerApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "factory"]
  defp elixirc_paths(:dev), do: ["lib", "factory"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.10"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:guardian, "~> 2.0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:bcrypt_elixir, "~> 2.0.3"},
      {:ecto_autoslug_field, "~> 0.3"},
      {:google_api_storage, "~> 0.13.0"},
      {:arc_gcs, "~> 0.1.0"},
      {:slugify, "~> 1.2"},
      {:uuid, "~> 1.1"},
      {:exsolr, git: "https://github.com/PabloG6/exsolr", override: true},
      {:arc_ecto, "~> 0.11.1"},
      {:goth, "~> 1.1.0"},
      {:corsica, "~> 1.1.2"},
      {:arc, "~> 0.11.0"},
      {:scrivener_ecto, "~> 2.2.0"},
      {:faker, "~> 0.13", only: [:test, :dev]},
      {:recase, "~> 0.5"},
      {:ex_machina, "~> 2.3", only: [:test, :dev]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds.exs"],

      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

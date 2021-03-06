defmodule KafkaExGateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :kafka_ex_gateway,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE*", "config/config.exs"],
      maintainers: ["kernelgarden"],
      licenses: ["Apache 2.0"]
    ]
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
      {:kafka_ex, "~> 0.8.3"},
      {:gen_stage, "~> 0.14.1"},
      {:deque, "~> 1.0"},
      {:poolboy, "~> 1.5"},
      {:protobuf, "~> 0.5.4"},
      {:google_protos, "~> 0.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end

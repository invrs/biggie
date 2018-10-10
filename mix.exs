defmodule Biggie.MixProject do
  use Mix.Project

  def project do
    [
      app: :biggie,
      version: "0.1.2",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:goth, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:google_api_big_query, "~> 0.1.0"},
      {:goth, "~> 0.6.0"},

      {:ex_doc, "~> 0.18.0", only: :dev}
    ]
  end

  defp description do
    """
    Biggie is an elixir client for interfacing with the
    [BigQuery REST API](https://cloud.google.com/bigquery/docs/reference/rest/v2/).
    """
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE),
      maintainers: ["Clayton Gentry"],
      licenses: ["Apache 2.0"],
      links: %{
        "Github" => "http://github.com/invrs/biggie",
        "Docs"   => "http://hexdocs.pm/biggie",
      }
    ]
  end
end

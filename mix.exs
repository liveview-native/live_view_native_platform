defmodule LiveViewNativePlatform.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_view_native_platform,
      version: "0.0.4",
      elixir: "~> 1.13",
      description: "Protocol library for implementing LiveView Native clients",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:jason, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:phoenix_html, "~> 3.0"},
      {:ecto, "~> 3.8"}
    ]
  end

  @source_url "https://github.com/liveviewnative/live_view_native_platform"

  # Hex package configuration
  defp package do
    %{
      maintainers: ["May Matyi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      },
      source_url: @source_url
    }
  end
end

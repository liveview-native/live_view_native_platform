defmodule LiveViewNativePlatform.MixProject do
  use Mix.Project

  @version "0.2.0-beta.0"

  def project do
    [
      app: :live_view_native_platform,
      version: @version,
      elixir: "~> 1.15",
      description: "Protocol library for implementing LiveView Native clients",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
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

  @source_url "https://github.com/liveview-native/live_view_native_platform"

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

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "overview",
      logo: "guides/assets/images/logo.png",
      assets: "guides/assets",
      extra_section: "GUIDES",
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules()
    ]
  end

  defp extras do
    [
      "guides/overview.md",
      "guides/creating-a-platform-library.md",
    ]
  end

  defp groups_for_extras do
    []
  end

  defp groups_for_modules do
    []
  end
end

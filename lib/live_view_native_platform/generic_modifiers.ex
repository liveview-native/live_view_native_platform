defmodule LiveViewNativePlatform.GenericModifiers do
  use LiveViewNativePlatform.Modifiers

  defimpl Jason.Encoder do
    def encode(%{stack: stack}, opts) do
      Jason.Encode.list(stack, opts)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(struct) do
      struct
      |> Jason.encode!()
      |> Phoenix.HTML.Engine.html_escape()
    end
  end
end

defmodule LiveViewNativePlatform.Context do
  @enforce_keys [:platform_id, :template_namespace]

  defstruct platform_config: nil,
            platform_id: nil,
            modifiers: nil,
            template_extension: nil,
            template_namespace: nil

  defimpl Phoenix.HTML.Safe do
    def to_iodata(data) do
      Phoenix.HTML.Safe.to_iodata(data.modifiers)
    end
  end
end

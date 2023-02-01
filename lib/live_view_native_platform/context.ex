defmodule LiveViewNativePlatform.Context do
  @enforce_keys [:platform_id, :template_namespace]

  defstruct custom_modifiers: [],
            modifiers: nil,
            platform_config: nil,
            platform_id: nil,
            platform_modifiers: [],
            template_engine: LiveViewNative.Engine,
            template_extension: nil,
            template_namespace: nil

  defimpl Phoenix.HTML.Safe do
    def to_iodata(data) do
      Phoenix.HTML.Safe.to_iodata(data.modifiers)
    end
  end
end

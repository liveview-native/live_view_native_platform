defmodule LiveViewNativePlatform.Context do
  @enforce_keys [:platform_id, :template_namespace]

  defstruct custom_modifiers: [],
            eex_engine: Phoenix.LiveView.TagEngine,
            modifiers: nil,
            platform_config: nil,
            platform_id: nil,
            platform_modifiers: [],
            tag_handler: LiveViewNative.TagEngine,
            template_extension: nil,
            template_namespace: nil

  defimpl Phoenix.HTML.Safe do
    def to_iodata(data) do
      Phoenix.HTML.Safe.to_iodata(data.modifiers)
    end
  end
end

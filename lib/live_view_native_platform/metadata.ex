defmodule LiveViewNativePlatform.Metadata do
  @enforce_keys [:platform_id, :template_namespace]

  defstruct platform_id: nil,
            modifiers: %{},
            template_extension: nil,
            template_namespace: nil
end

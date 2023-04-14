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

  import LiveViewNativePlatform.Utils, only: [introspect_module: 2, introspect_modules: 2]

  def define(platform_id, opts \\ []) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    temolate_extension = Keyword.get(opts, :template_extension, ".#{platform_id}.heex")

    with spec <- Application.spec(otp_app),
         [_ | _] = modules <- Keyword.get(spec, :modules),
         namespace <- introspect_module(modules, :platform),
         platform_modifiers <- introspect_modules(modules, :modifier),
         keyed_platform_modifiers <- key_platform_modifiers(platform_modifiers)
    do
      %__MODULE__{
        custom_modifiers: Keyword.get(opts, :custom_modifiers, []),
        modifiers: modifiers_struct(modules),
        platform_id: platform_id,
        platform_modifiers: keyed_platform_modifiers,
        tag_handler: Keyword.get(opts, :tag_handler, LiveViewNative.TagEngine),
        template_extension: temolate_extension,
        template_namespace: Keyword.get(opts, :template_namespace, namespace),
      }
    else
      error ->
        raise "Unexpected return value: #{inspect error}"
    end
  end

  ###

  defp key_platform_modifiers(modifiers) do
    Enum.reduce(modifiers, [], fn modifier, acc ->
      %{modifier_name: modifier_name} = apply(modifier, :__lvn_modifier__, [])

      # This is only called at compile-time so it should be considered safe
      modifier_name_as_atom = String.to_atom(modifier_name)

      Keyword.put(acc, modifier_name_as_atom, modifier)
    end)
  end

  defp modifiers_struct(modules) do
    case introspect_module(modules, :modifiers) do
      nil ->
        nil

      module ->
        struct(module, %{})
    end
  end
end

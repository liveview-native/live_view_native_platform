defmodule LiveViewNativePlatform.Env do
  @moduledoc """
  Provides information about a LiveView Native platform.
  """

  @enforce_keys [:platform_id, :template_namespace]

  defstruct custom_modifiers: [],
            default_layouts: %{},
            eex_engine: Phoenix.LiveView.TagEngine,
            modifiers_struct: nil,
            modifiers: nil,
            platform_config: nil,
            platform_id: nil,
            platform_modifiers: [],
            render_macro: nil,
            tag_handler: LiveViewNative.TagEngine,
            template_extension: nil,
            template_namespace: nil,
            valid_targets: []

  defimpl Phoenix.HTML.Safe do
    def to_iodata(data) do
      Phoenix.HTML.Safe.to_iodata(data.modifiers)
    end
  end

  import LiveViewNativePlatform.Utils, only: [introspect_module: 2, introspect_modules: 2]

  @doc """
  Define a new LiveView Native Platform. This function should only be called at compile-time.
  """
  def define(platform_id, opts \\ []) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    render_macro = Keyword.get(opts, :render_macro)
    template_extension = Keyword.get(opts, :template_extension, ".#{platform_id}.heex")

    with spec <- Application.spec(otp_app),
         modules <- spec[:modules] || [],
         namespace <- introspect_module(modules, :platform),
         platform_modifiers <- introspect_modules(modules, :modifier),
         keyed_platform_modifiers <- key_platform_modifiers(platform_modifiers),
         modifiers <- modifiers_struct(modules) do
      %__MODULE__{
        custom_modifiers: Keyword.get(opts, :custom_modifiers, []),
        default_layouts: Keyword.get(opts, :default_layouts, %{
          app: "<%= @inner_content %>",
          root: """
            <csrf-token value={get_csrf_token()} />
            <%= @inner_content %>
          """
        }),
        modifiers_struct: modifiers.__struct__ || LiveViewNativePlatform.GenericModifiers,
        modifiers: modifiers,
        platform_id: platform_id,
        platform_modifiers: keyed_platform_modifiers,
        render_macro: render_macro,
        tag_handler: Keyword.get(opts, :tag_handler, LiveViewNative.TagEngine),
        template_extension: template_extension,
        template_namespace: Keyword.get(opts, :template_namespace, namespace),
        valid_targets: Keyword.get(opts, :valid_targets, [])
      }
    else
      error ->
        raise "Unexpected return value: #{inspect(error)}"
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
        %LiveViewNativePlatform.GenericModifiers{}

      module ->
        struct(module, %{})
    end
  end
end

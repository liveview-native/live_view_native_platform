defmodule LiveViewNativePlatform.Modifier do
  defmacro __using__(_) do
    quote do
      import LiveViewNativePlatform.Modifier,
        only: [
          modifier_schema: 1,
          modifier_schema: 2,
          change_event: 0
        ]
    end
  end

  defmacro change_event() do
    quote do
      field(:change, LiveViewNativePlatform.Modifier.Types.Event, default: nil)
    end
  end

  defmacro modifier_schema(modifier_name) do
    quote do
      modifier_schema(unquote(modifier_name), do: {:__block__, [], []})
    end
  end

  defmacro modifier_schema(modifier_name, do: block) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key false
      @derive Jason.Encoder
      schema(unquote(modifier_name)) do
        unquote(block)
      end

      def __lvn_modifier__, do: %{
        modifier_name: unquote(modifier_name)
      }

      def changeset(modifier \\ %__MODULE__{}, attrs) do
        modifier
        |> cast(attrs, fields())
      end

      def fields do
        __schema__(:fields)
      end

      def modifier(modifier \\ %__MODULE__{}, attrs)

      def modifier(modifier, attrs) when is_map(attrs) do
        modifier
        |> changeset(attrs)
        |> Ecto.Changeset.apply_changes()
      end

      def modifier(modifier, attrs) when is_list(attrs) do
        modifier(modifier, Enum.into(attrs, %{}))
      end

      def modifier_name do
        __schema__(:source)
      end

      def to_map(modifier \\ %__MODULE__{}) do
        modifier
        |> Map.from_struct()
        |> Map.delete(:__meta__)
      end
    end
  end
end

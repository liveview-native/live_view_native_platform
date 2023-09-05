defmodule LiveViewNativePlatform.Modifier.Type do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Type

      def load(_), do: :error

      def dump(_), do: :error
    end
  end
end

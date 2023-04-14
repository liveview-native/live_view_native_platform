defmodule LiveViewNativePlatform.Modifiers do
  defmacro __using__(_) do
    quote do
      @moduledoc false
      defstruct stack: []

      defimpl LiveViewNativePlatform.ModifiersStack do
        def append(%{stack: stack} = modifiers, modifier) do
          stack = stack || []

          %{modifiers | stack: stack ++ [modifier]}
        end
      end

      def __lvn_modifiers__, do: true
    end
  end
end

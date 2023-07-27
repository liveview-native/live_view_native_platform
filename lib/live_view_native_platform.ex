defmodule LiveViewNativePlatform do
  defmacro __using__(_) do
    quote do
      def __lvn_platform__, do: true
    end
  end
end

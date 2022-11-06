defmodule LiveViewNativePlatform.Modifier do
  defmacro __using__(opts) do
    quote do
      def __live_view_native_modifier__ do
        unquote(opts)
      end

      def put_modifier(ctx, opts \\ []) do
        IO.inspect ctx
      end
    end
  end
end

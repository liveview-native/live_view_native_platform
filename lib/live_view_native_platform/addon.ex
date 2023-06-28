defmodule LiveViewNativePlatform.Addon do
  defmacro __using__([otp_app: otp_app]) do
    quote do
      def otp_app, do: unquote(otp_app)
    end
  end
end

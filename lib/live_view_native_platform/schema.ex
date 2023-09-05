defmodule LiveViewNativePlatform.Schema do
  @moduledoc false

  defmacro __using__(opts) do
    {_op, _meta, args} = Keyword.get(opts, :params, %{})
    struct_keys = Keyword.keys(args)
    struct_fields = Enum.map(struct_keys, &{&1, nil})

    quote do
      defstruct unquote(struct_fields)
    end
  end
end

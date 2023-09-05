# Creating a Platform Library

To create a platform library that can be used as a dependency within a LiveView Native application, a few requirements must be met:

1. Your library must have a top-level module with `use LiveViewNativePlatform`.
2. Your top-level module must define a `platforms/0` function which returns a list of platform modules.
3. Your library must have at least one platform module that implements the `LiveViewNativePlatform.Kit` protocol.

This document briefly covers each of these requirements.

> #### Info {: .info}
> For an example of a LiveView Native platform library, look through the source code of `live_view_native_swift_ui` [here](https://github.com/liveview-native/liveview-client-swiftui).

## Top-level module

The top-level module of your library must inherit the `LiveViewNativePlatform` macro and define a `platforms/0` callback. Here's a basic example of what that might look like:

```elixir
defmodule LiveViewNativeExampleLib do
  use LiveViewNativePlatform

  def platforms,
    do: [
      LiveViewNativeExampleLib.Platform
    ]
end
```

This is the entry point of your platform library. At compile-time, a LiveView Native application will look for any modules that inherit the `LiveViewNativePlatform` macro and call `platforms/0` on all of them. The returned list of platforms is used to tell the application which platforms are available and describe how they will be used in an application.

## Implementing a Kit

Each platform module returned by `platforms/0` in the previous step must implement the `LiveViewNativePlatform.Kit` protocol. This protocol expects one function called `compile/1` to be implemented, which returns a `%LiveViewNativePlatform.Env{}` struct. This struct has the following properties:

- `custom_modifiers`: A list of custom modifiers, defined by the end-user.
- `eex_engine`: The EEx engine to use for compiling templates. Defaults to `Phoenix.LiveView.TagEngine`.
- `modifiers_struct`: The module to use for modifier structs. Defaults to `LiveViewNativePlatform.GenericModifiers`.
- `modifiers`: An empty struct with the `modifiers_struct` module.
- `platform_config`: The module to use for platform configuration structs. This is typically used to store platform-specific information sent by the client, like OS name, version, device type, etc.
- `platform_id`: A unique platform ID.
- `platform_modifiers`: A keyword list of modifier names and their associated modifier schema modules. Defaults to an empty list.
- `render_macro`: A macro or sigil to use for rendering function components for this platform.
- `tag_handler`: A tag handler module to use for parsing templates. This is only relevant when `eex_engine` is `Phoenix.LiveView.TagEngine`. Defaults to `LiveViewNative.TagEngine`.
- `template_extension`: A unique file extension to use for external template files. Defaults to `"#{platform_id}.heex"`
- `template_namespace`: Your library's top-level module name.

Most of these fields are optional and many of them are dynamically set at runtime when your platform library is used in end-user applications. Instead of returning a struct directly, it is recommended to use `LiveViewNativePlatform.Env.define/2` to only set the fields you need. Here is an example:

```elixir
defmodule LiveViewNativeExampleLib.Platform do
  defstruct [
    :os_version,
    :simulator_opts,
    :another_custom_field,
    # etc...
  ]

  defimpl LiveViewNativePlatform.Kit do
    require Logger

    def compile(_config) do
      LiveViewNativePlatform.Env.define(:example_lib, # A unique ID to identify your platform by 
        render_macro: :sigil_EXAMPLE, # This will allow rendering platform-specific with `~EXAMPLE""`
        otp_app: :live_view_native_example_lib # This is used to infer other values in the struct
      )
    end
  end
end
```

This will allow LiveView Native applications to use your platform library, like so:

```elixir
# lib/my_app_web/live/hello_live.ex
defmodule MyAppWeb.HelloLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  @impl true
  def render(%{platform_id: :example_lib} = assigns) do
    # This UI renders on your custom client
    # Note: This is pseudocode; your native platform's template syntax will vary.
    ~EXAMPLE"""
    <NativeContainerElement>
      <NativeContainerText>
        Hello native!
      </NativeContainerText>
    </NativeContainerElement>
    """
  end

  @impl true
  def render(%{} = assigns) do
    # This UI renders on the web
    ~H"""
    <div class="flex w-full h-screen items-center">
      <span class="w-full text-center">
        Hello web!
      </span>
    </div>
    """
  end
end
```

A client can connect to a LiveView Native application that supports your platform library by passing its unique platform ID as the `_platform` connection param (this is handled by [`LiveViewNative.LiveSession`](https://hexdocs.pm/live_view_native/LiveViewNative.LiveSession.html)). So in this example, connecting to `http://localhost:4000?_platform=example_lib` will render the `~EXAMPLE""` template and connecting to `http://localhost:4000` will render the web template.

## Modifiers

LiveView Native Platform supports modifiers for platforms that use them, like SwiftUI and Jetpack Compose. Your native platform might not have a need for modifiers; if not, you can ignore modifiers entirely in your platform library implementation.

If you want to use modifiers in your platform library, consider looking at how the `live_view_native_swift_ui` platform library does it as a reference. The `modifiers_struct` set on your `%LiveViewNativePlatform.Env{}` will need to implement the following protocols to fully support modifiers:

- `LiveViewNativePlatform.ModifiersStack`
- `Jason.Encoder`
- `Phoenix.HTML.Safe`

## Conclusion

This document outlined the bare minimum requirements for a platform library to be used within a LiveView Native application. More advanced topics, such as building a client library with LiveView compatibility, how to integrate `liveview-native-core` into your client library using FFI, and native platform development in general, are beyond the scope of this library and guide.
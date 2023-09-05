# Overview

LiveView Native Platform is an auxillary library to [LiveView Native](https://hexdocs.pm/live_view_native/). It defines protocols, macros and other supporting code for developers to add LiveView Native support to their own native clients.

This library provides the serverside glue between Phoenix applications using `live_view_native` and platform libraries (like `live_view_native_swift_ui` and `live_view_native_jetpack`).

> #### Warning {: .warning}
> This dependency is intended for library developers and shouldn't be used for end-user developers who want to use LiveView Native within their application.
> For information on using LiveView Native within an application, check the HexDocs for the `live_view_native` library [here](https://hexdocs.pm/live_view_native/).
>

## Getting Started

Platform libraries for LiveView Native have two essential layers; the serverside Elixir code that the `live_view_native` library knows how to interface with, and the clientside code that provides compatibility with Phoenix LiveView backends. This library and documentation only focuses on the serverside responsibilities of a platform library.

For information on the clientside implementation needed to support LiveView Native, see [`liveview-native-core`](https://github.com/liveview-native/liveview-native-core). It provides platform-agnostic implementations of [morphdom](https://github.com/patrick-steele-idem/morphdom), Phoenix sockets and other essential glue code that one could use to build a LiveView Native compatible client.

To use LiveView Native Platform in your platform library, simply include it as a dependency in your `mix.exs`:

```elixir
def deps do
  [
    # other dependencies here...
    {:live_view_native_platform, "~> 0.1.0"}
  ]
end
```

You do not need to pull in any Phoenix, LiveView or other dependencies in your platform library; this library does not depend on them and end-user applications who are using `live_view_native` will already have those dependencies in their project.

After running `mix deps.get`, you can continue on to [creating a platform library](./creating-a-platform-library.md).
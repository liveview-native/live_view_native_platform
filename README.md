# LiveViewNativePlatform

 [![Hex.pm](https://img.shields.io/hexpm/v/live_view_native_platform.svg)](https://hex.pm/packages/live_view_native_platform)

## Installation

To use LiveView Native Platform, add it to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:live_view_native_platform, "~> 0.0.6"}]
end
```

## About

LiveView Native Platform is the core Elixir dependency for [LiveView Native](https://github.com/liveview-native/live_view_native) client platforms. It provides protocols, macros and configuration functions that allow repositories like [liveview-client-swiftui](https://github.com/liveview-native/liveview-client-swiftui) to be used as a target of LiveView Native applications. This repository is only intended for client platform developers looking to add support for LiveView Native to their own native code; you should not need to pull this dependency into a LiveView Native application directly.

## Usage

To add support for LiveView Native, a client platform must implement the `LiveViewNativePlatform` protocol. Here's a barebones example of a module that implements this protocol:

```elixir
# lib/live_view_native_example_platform/platform.ex
defmodule LiveViewNativeExamplePlatform.Platform do
  defimpl LiveViewNativePlatform do
    def context(struct) do
      LiveViewNativePlatform.Context.define(:my_platform, # The unique `platform_id`
        custom_modifiers: struct.custom_modifiers, # Can be omitted if custom modifiers should not be supported
        tag_handler: LiveViewNativeExamplePlatform.TagEngine, # Optional, defaults to `LiveViewNative.TagEngine`
        template_extension: ".myp.heex", # Optional, defaults to ".#{platform_id}.heex"
        otp_app: :live_view_native_example_platform # The OTP app name of your platform library
      )
    end

    def start_simulator(struct, opts \\ []) do
      # This will be called when an end-user calls
      # `LiveViewNative.start_simulator!(:my_platform)`
      System.cmd("my_native_process", [])
    end
  end
end
```

Here `LiveViewNativePlatform.Context.define/3` takes a unique atom to use for identifying the platform and an option list of parameters. These parameters can be used to change certain aspects of the platform. In addition to this protocol, LiveView Native platform libraries must inherit the `LiveViewNativePlatform.Platform` macro on the top-level module of the library:

```elixir
defmodule LiveViewNativeExamplePlatform do
  use LiveViewNativePlatform.Platform
end
```

LiveView Native platform libraries will likely also require platform-specific code to run on the client and provide "native" compatibility for the Phoenix LiveView protocol. That code can coexist with the Elixir library (example [here](https://github.com/liveview-native/liveview-client-swiftui)) or be provided by a separate package. For the non-Elixir requirements needed to support LiveView Native within a native client, you might consider using [liveview-native-core](https://github.com/liveview-native/liveview-native-core) as a dependency within your library.

## Learn more

  * Official website: https://native.live
  * Docs: https://hexdocs.pm/live_view_native_platform
  * Source: https://github.com/liveviewnative/live_view_native_platform

defmodule LiveViewNativePlatform.Utils do
  @moduledoc false

  @introspect_keys %{
    modifier: :__lvn_modifier__,
    modifiers: :__lvn_modifiers__,
    platform: :__lvn_platform__
  }
  @introspect_types Map.keys(@introspect_keys)

  def check_attribute(value, :must_be_string) when is_binary(value), do: {:must_be_string, true}
  def check_attribute(_value, :must_be_string), do: {:must_be_string, false}

  def check_attribute(value, :must_point_to_directory) when is_binary(value) do
    path = Path.expand(value)

    {:must_point_to_directory, File.dir?(path)}
  end

  def check_attribute(_value, :must_point_to_directory), do: {:must_point_to_directory, false}

  def check_dependency(command) do
    case System.find_executable(command) do
      nil ->
        {:error, {command, :not_found}}

      path ->
        {:ok, path}
    end
  end

  def check_dependency!(command) do
    case check_dependency(command) do
      {:ok, path} ->
        path

      _ ->
        raise ~s(Command "#{command}" not found)
    end
  end

  def check_platform(%_struct{} = platform_struct, checks \\ %{}) do
    platform_struct
    |> Map.from_struct()
    |> Enum.reduce({:ok, %{}}, fn {key, value}, {status, results} ->
      case Map.get(checks, key) do
        [_ | _] = checks ->
          check_results = Enum.map(checks, &check_attribute(value, &1))

          new_status =
            if Enum.all?(check_results, fn {_key, value} -> value end), do: status, else: :error

          {new_status, Map.put(results, key, check_results)}

        _ ->
          {status, Map.put(results, key, [])}
      end
    end)
  end

  def check_platform!(%_struct{} = platform_struct, checks \\ %{}) do
    case check_platform(platform_struct, checks) do
      {:ok, result} ->
        result

      {:error, result} ->
        raise "check_platform!/2 failed with result: #{inspect(result)}"
    end
  end

  def introspect_module(modules, type) when type in @introspect_types do
    Enum.find(modules, fn module ->
      introspect_key = @introspect_keys[type]
      functions = apply(module, :__info__, [:functions])

      Keyword.has_key?(functions, introspect_key)
    end)
  end

  def introspect_modules(modules, type) when type in @introspect_types do
    Enum.filter(modules, fn module ->
      introspect_key = @introspect_keys[type]
      functions = apply(module, :__info__, [:functions])

      Keyword.has_key?(functions, introspect_key)
    end)
  end

  def run_command(command, args, opts \\ []) do
    format = Keyword.get(opts, :format, :raw)

    case System.cmd(command, args) do
      {result, 0} when format == :json ->
        {:ok, Jason.decode!(result)}

      {result, 0} ->
        {:ok, result}

      {result, _error_code} when format == :json ->
        {:error, Jason.decode!(result)}

      {result, _error_code} ->
        {:error, result}
    end
  end

  def run_command!(command, args, opts \\ []) do
    case run_command(command, args, opts) do
      {:ok, result} ->
        result

      {:error, result} ->
        raise "#{inspect(command)} failed with result: #{inspect(result)}"
    end
  end
end

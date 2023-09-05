defprotocol LiveViewNativePlatform.ModifiersStack do
  @moduledoc """
  Protocol for representing a chain of applied modifiers.
  """

  @doc "Appends a modifier to the modifiers stack"
  def append(struct, modifiers)
end

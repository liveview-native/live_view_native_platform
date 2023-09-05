defprotocol LiveViewNativePlatform.Kit do
  @moduledoc """
  Protocol for representing a LiveView Native platform or add-on.
  """

  @doc "Returns a struct containing information about the kit"
  def compile(struct)
end

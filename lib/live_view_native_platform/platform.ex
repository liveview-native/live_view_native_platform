defprotocol LiveViewNativePlatform.Platform do
  @doc "Returns a struct containing information about the platform"
  def platform_meta(struct)

  @doc "Starts a new instance of the client simulator"
  def start_simulator(struct, opts)
end

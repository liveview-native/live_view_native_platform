defprotocol LiveViewNativePlatform.Kit do
  @doc "Returns a struct containing information about the kit"
  def compile(struct)
end

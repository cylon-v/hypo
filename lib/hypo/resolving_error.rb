class ResolvingError < StandardError
  def initialize(name)
    super("Component #{name} is not registered")
  end
end
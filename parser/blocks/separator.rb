require_relative "block"

class Separator < Block
  def initialize(_)
  end

  def render(**opts)
    @width = opts[:width]
    "━" * @width
  end
end

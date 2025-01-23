class Renderer
  def initialize(blocks, width:)
    @blocks = blocks
    @width = width
  end

  def render
    @blocks.map { |block| block.render(width: @width) }
  end
end

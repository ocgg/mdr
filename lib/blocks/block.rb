require_relative "text_renderer"

# Block receives a type and raw content from the Parser.
# It formats its content regarding to its type.
class Block
  attr_reader :content

  def initialize(content)
    # @type = args[:type]
    # @spec = nil
    @content = format(content)
  end

  private

  # RENDERING #################################################################

  def spans_to_string(spans)
    TextRenderer.spans_to_string(spans)
  end

  def content_to_lines(content: @content, width: @width, align: nil)
    renderer = TextRenderer.new(width, align)
    renderer.make_lines(content)
  end
end

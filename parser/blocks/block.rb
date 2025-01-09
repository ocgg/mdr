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

  # FORMATING #################################################################

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end

  # RENDERING #################################################################

  def spans_to_string(spans)
    # TODO: fix nil nil nil
    TextRenderer.spans_to_string(spans)
  end

  # def content_to_lines(width: @width, word_wrap: true, align: nil)
  def content_to_lines(width: @width, word_wrap: true, align: nil)
    renderer = TextRenderer.new(width, word_wrap, align)

    @content.spans.each_with_object(renderer) do |span, lh|
      lh.make_lines!(span)
    end
    renderer.finish_line!
    renderer.lines
  end
end

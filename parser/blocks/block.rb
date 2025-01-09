require_relative "text_renderer"
require_relative "code_renderer"

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

  def code_to_lines(code, lang)
    renderer = CodeRenderer.new(@width)
    renderer.codeblock(code, lang)
  end

  def spans_to_string(spans)
    TextRenderer.spans_to_string(spans)
  end

  # def content_to_lines(width: @width, word_wrap: true, align: nil)
  def content_to_lines(width: @width, align: nil)
    renderer = TextRenderer.new(width, align)

    @content.spans.each do |span|
      renderer.make_lines!(span)
    end
    renderer.finish_line!
    renderer.lines
  end
end

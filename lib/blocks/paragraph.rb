require_relative "block"
require_relative "text"

class Paragraph < Block
  def render(**opts)
    @width = opts[:width]
    content_to_lines.join("\n")
  end

  private

  def format(string)
    Text.new(string)
  end
end

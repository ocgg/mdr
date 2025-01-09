require_relative "block"
require_relative "text"

class Paragraph < Block
  def format(content)
    content = content.strip.tr("\n", " ").squeeze(" ")
    Text.new(content)
  end

  def render(**opts)
    @width = opts[:width]
    content_to_lines.join("\n")
  end
end

require_relative "block"
require_relative "text"

class Paragraph < Block
  def format(content)
    content = content.strip.tr("\n", " ").squeeze(" ")
    Text.new(content)
  end
end

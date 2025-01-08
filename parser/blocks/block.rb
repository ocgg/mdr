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

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end
end

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

  # def format(content)
  #   case @type
  #   when :codeblock then content
  #   when :unord_list then list_content(content)
  #   else
  #     strip_and_squeeze(content)
  #   end
  # end

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end
end

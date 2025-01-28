require_relative "blocks/title"
require_relative "blocks/separator"
require_relative "blocks/codeblock"
require_relative "blocks/table"
require_relative "blocks/list"
require_relative "blocks/quote"
require_relative "blocks/paragraph"

# Parser parse a raw markdown file and translate it into Block objects.
# NB: content formatting happens in Block class.
class Parser
  attr_reader :blocks

  def initialize(raw)
    @block_regexs = {
      Title => /((?:^ {0,3}\#{1,6} .+$)|(?:^ {0,3}(?:.|\\\n?)+?\n {,3}(?:=+|-+) *$))/,
      Separator => /^ {0,3}(-{3,}|\*{3,})$/,
      Table => /^ {0,3}(\|?(?:.*\|.*)+\|?\n\|?(?::?-+:?\|?)+(?:\n\|?.+\|?)*)/,
      Codeblock => /^\s{0,3}(```\w*?\n(?:.|\n)*?```)/,
      List => /^ {0,3}((?:(?:[-*+](?: \[[Xx ]\])?|\d+[.)]) .*(?:\n.+)*(?:\n|$))+)/,
      Quote => /^ {0,3}((?:>\s{,3})+(?:.\n?)*)/,
      Paragraph => /^ {0,3}((?:.\n?)+)/
    }
    @blocks = parse(raw)
  end

  private

  def parse(raw)
    types = @block_regexs.keys
    raw.scan(/#{@block_regexs.values.join("|")}/).map do |data|
      # find index of non-nil data
      id = data.find_index { |match| !match.nil? }
      block_class = types[id]
      content = data[id]
      block_class.new(content)
    end
  end
end

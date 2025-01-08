require_relative "parser/blocks/title"
require_relative "parser/blocks/separator"
require_relative "parser/blocks/codeblock"
require_relative "parser/blocks/table"
require_relative "parser/blocks/list"
require_relative "parser/blocks/paragraph"

# Parser parse a raw markdown file and translate it into Block objects.
# NB: content formatting happens in Block class.
class Parser
  attr_reader :blocks

  BLOCK_REGEXS = {
    title: /^\s{0,3}(\#{1,6} .+)$/,
    separator: /^\s{0,3}([-*]{3,})$/,
    table: /^\s{0,3}((?:\|[^|\n]*\n?)+)/,
    codeblock: /^\s{0,3}(```\w*?\n(?:.|\n)*?```)/,
    list: /^\s{0,3}((?:\s*- .*(?:\n.+)*(?:\n+|$))+)/,
    paragraph: /^\s{0,3}(.*)/
  }

  def initialize(raw)
    @blocks = parse(raw)
  end

  private

  def parse(raw)
    types = [
      Title,
      Separator,
      Table,
      Codeblock,
      List,
      Paragraph
    ]
    raw.scan(/#{BLOCK_REGEXS.values.join("|")}/).map do |data|
      # find index of non-nil data
      id = data.find_index { |match| !match.nil? }
      type = types[id]
      content = data[id]
      type.new(content)
    end
  end
end

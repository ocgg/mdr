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

  REGEXS = {
    title: /^\s{0,3}(\#{1,6} .+)$/,
    separator: /^\s{0,3}([-*]{3,})$/,
    table: /^\s{0,3}((?:\|[^|\n]*\n?)+)/,
    codeblock: /^\s{0,3}(```\w*?\n(?:.|\n)*?```)/,
    unord_list: /^\s{0,3}((?:\s*- .*(?:\n.+)*(?:\n+|$))+)/,
    paragraph: /^\s{0,3}(.*)/
  }

  def initialize(raw)
    @blocks = parse(raw)
  end

  private

  # FORMATING #################################################################

  # Receive a raw string possibly dirty markdown,
  # Ouputs a list string with indented, squeezed, un-newlined lines.
  def format_list(list)
    list.squeeze("\n").split("\n").reduce("") do |result, line|
      next line if result.empty?
      next "#{result} #{strip_and_squeeze(line)}" unless line.match?(/(^\s*- )/)

      indent_level = case line
      when /^\s?- / then 0
      when /^\s{2,3}- / then 1
      when /^(\s{4,})- / then $1.length / 2
      end
      indent = "  " * indent_level

      "#{result}\n#{indent}#{strip_and_squeeze(line)}"
    end
  end

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end

  def parse(raw)
    types = [
      Title,
      Separator,
      Table,
      Codeblock,
      List,
      Paragraph
    ]
    blocks = raw.scan(/#{REGEXS.values.join("|")}/).map do |data|
      # find index of non-nil data
      id = data.find_index { |match| !match.nil? }
      type = types[id]
      content = data[id]
      type.new(content)
    end
    pp blocks
    # Should return a MdDocument
  end
end

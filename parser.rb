require_relative "parser/block"

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
    list.squeeze("\n").split("\n").reduce("") do |acc, line|
      next line if acc.empty?
      next "#{acc} #{strip_and_squeeze(line)}" unless line.match?(/(^\s*- )/)

      indent_level = case line
      when /^\s?- / then 0
      when /^\s{2,3}- / then 1
      when /^(\s{4,})- / then $1.length / 2
      end
      indent = "  " * indent_level

      "#{acc}\n#{indent}#{strip_and_squeeze(line)}"
    end
  end

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end

  # PARSING ###################################################################

  def block_from(type, content)
    p content
    content = case type
    when :codeblock then content
    when :unord_list then format_list(content)
    when :title, :separator, :table, :paragraph
      strip_and_squeeze(content)
    else
      content
    end

    {type:, content:}
  end

  # Splits raw markdown file at 2 or more newlines
  # return an array of hashes representing blocks with keys :title & :content
  def parse(raw)
    types = [
      :title,
      :separator,
      :table,
      :codeblock,
      :unord_list,
      :paragraph
    ]
    blocks = raw.scan(/#{REGEXS.values.join("|")}/).map do |data|
      # find index of non-nil data
      id = data.find_index { |match| !match.nil? }
      type = types[id]
      content = data[id]
      block_from(type, content)
    end
    pp blocks
    raise
    # Should return a MdDocument
  end
end

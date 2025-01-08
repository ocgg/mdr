require_relative "block"
require_relative "text"

class List < Block
  def initialize(content)
    super
    parse_text_content
  end

  private

  def find_parent(item, diff)
    if diff.positive? then item
    elsif diff.zero? then item[:parent]
    else
      find_parent(item[:parent], diff + 1)
    end
  end

  def parse_text_content
    @content.each do |item|
      item[:content] = Text.new(item[:content])
    end
  end

  def format(string)
    string = string.squeeze("\n").split("\n")
    first_line = strip_and_squeeze(string.first)[2..]
    first_item = {indent_level: 0, parent: nil, content: first_line, children: []}
    last_added = first_item

    string[1..].each_with_object([first_item]) do |line, items|
      left_part = line.slice!(/^\s*- /)

      unless left_part
        last_added[:content] += " #{strip_and_squeeze(line)}"
        next items
      end

      indent_level = (left_part.size - 2) / 2
      indent_diff = indent_level - last_added[:indent_level]

      parent = indent_level.zero? ? nil : find_parent(last_added, indent_diff)
      line = strip_and_squeeze(line)
      item = {indent_level:, parent:, content: line, children: []}
      parent ? parent[:children] << item : items << item
      last_added = item
    end
  end
end

require_relative "block"
require_relative "text"

class Item
  attr_reader :parent, :children, :indent_level
  attr_accessor :content

  def initialize(**args)
    @parent = args[:parent]
    @children = args[:children] || []
    @indent_level = args[:indent_level] || 0
    @content = args[:content]
  end

  def sign
    case @indent_level
    when 0 then "•"
    when 1 then "◦"
    else "▪"
    end
  end

  def indents = "  " * @indent_level
end

class List < Block
  def render(**opts)
    @width = opts[:width]
    list_to_lines.join("\n")
  end

  private

  # FORMATING #################################################################

  def format(string)
    string = string.squeeze("\n").split("\n")
    first_line = strip_and_squeeze(string.first)[2..]
    first_item = Item.new(content: first_line)
    last_added = first_item

    string[1..].each_with_object([first_item]) do |line, items|
      left_part = line.slice!(/^\s*- /)

      unless left_part
        last_added.content += " #{strip_and_squeeze(line)}"
        next items
      end

      indent_level = (left_part.size - 2) / 2
      indent_diff = indent_level - last_added.indent_level

      parent = indent_level.zero? ? nil : find_parent(last_added, indent_diff)
      line = strip_and_squeeze(line)
      item = Item.new(indent_level:, parent:, content: line)
      parent ? parent.children << item : items << item
      last_added = item
    end
  end

  def find_parent(item, diff)
    if diff.positive? then item
    elsif diff.zero? then item.parent
    else
      find_parent(item.parent, diff + 1)
    end
  end

  # RENDERING #################################################################

  def item_to_lines(item, lines)
    width = @width - (4 + (item.indent_level * 2))
    alines = content_to_lines(content: item.content, width:)
    alines.each_with_index do |line, i|
      sign = i.zero? ? item.sign : " "
      prefix = "#{item.indents}#{sign}"
      lines << "  #{prefix} #{line}"
    end
  end

  def list_to_lines(items = @content, lines = [])
    items.each do |item|
      item.content = Text.new(item.content)
      item_to_lines(item, lines)
      list_to_lines(item.children, lines)
    end
    lines
  end
end

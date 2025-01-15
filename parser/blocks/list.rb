require_relative "block"
require_relative "text"

class Item
  attr_reader :parent, :children, :indent_level, :sign
  attr_accessor :content

  def initialize(**args)
    @tab = args[:tab]
    @parent = args[:parent]
    @content = args[:content]
    @children = args[:children] || []
    @indent_level = args[:indent_level] || 0
    @sign = find_sign
  end

  def find_sign
    case @indent_level
    when 0 then "•"
    when 1 then "◦"
    else "▪"
    end
  end

  def indents = "#{@tab} " * @indent_level

  def indent_width = indents.size
end

class List < Block
  TAB = "  "

  def render(**opts)
    @width = opts[:width]
    list_to_lines.join("\n")
  end

  private

  # FORMATING #################################################################

  def format(string)
    string_items = string.split(/((?:.(?:\\\n)?)*?)\n/).reject(&:empty?)

    last_added = nil
    string_items.each_with_object([]) do |line, items|
      left_part = line.slice!(/^\s*- /)

      unless left_part
        last_added.content.append_str(" #{line}")
        next items
      end

      indent_level = (left_part.size - 2) / 2
      indent_diff = indent_level - last_added.indent_level if last_added

      parent = indent_level.zero? ? nil : find_parent(last_added, indent_diff)
      item = Item.new(tab: TAB, indent_level:, parent:, content: Text.new(line))
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
    indent_width = TAB.size + item.indents.size + 2
    width = @width - indent_width
    sublines = content_to_lines(content: item.content, width:)
    sublines.each_with_index do |line, i|
      sign = i.zero? ? item.sign : " "
      prefix = "#{item.indents}#{sign}"
      lines << "#{TAB}#{prefix} #{line}"
    end
  end

  def list_to_lines(items = @content, lines = [])
    items.each do |item|
      item_to_lines(item, lines)
      list_to_lines(item.children, lines)
    end
    lines
  end
end

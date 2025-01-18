require_relative "block"
require_relative "text"
require_relative "list_item"

class List < Block
  TAB = "  "

  def render(**opts)
    @width = opts[:width]
    list_to_lines.join("\n")
  end

  private

  # RENDERING #################################################################

  def item_to_lines(item, lines)
    indent_width = TAB.size + item.indents.size + item.sign.size + 1
    width = @width - indent_width
    sublines = content_to_lines(content: item.content, width:)
    sublines.each_with_index do |line, i|
      sign = i.zero? ? item.sign : " "
      prefix = "#{item.indents}#{sign}"
      lines << "#{TAB}#{prefix} #{line}"
    end
  end

  def list_to_lines(items = @items, lines = [])
    items.each do |item|
      item_to_lines(item, lines)
      list_to_lines(item.children, lines)
    end
    lines
  end

  # FORMATING #################################################################

  def format(string)
    @items = []
    @last_added = nil

    string_items = string.split(/((?:.(?:\\\n)?)*?)\n/).reject(&:empty?)
    string_items.each do |line|
      left_part = line.slice!(/^ *([-*+]|\d+[.)]) /)

      unless left_part
        @last_added.content.append_str(" #{line}")
        next @items
      end

      ordered = left_part.match?(/\d/)
      indent_level = (left_part.size - 2) / 2
      indent_diff = indent_level - @last_added.indent_level if @last_added
      parent = indent_level.zero? ? nil : find_parent(@last_added, indent_diff)
      order_nb = parent ? parent.children.size : @items.size
      items_opts = {ordered:, tab: TAB, indent_level:, parent:, order_nb:, content: Text.new(line)}

      add_item(parent, items_opts)
    end
  end

  def add_item(parent, opts)
    item = ListItem.new(opts)
    parent ? parent.children << item : @items << item
    @last_added = item
  end

  def find_parent(item, diff)
    if diff.positive? then item
    elsif diff.zero? then item.parent
    else
      find_parent(item.parent, diff + 1)
    end
  end
end

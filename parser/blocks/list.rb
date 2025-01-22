require_relative "block"
require_relative "text"
require_relative "list_item"

class List < Block
  TAB = 2

  def render(**opts)
    @width = opts[:width]
    list_to_lines.join("\n")
  end

  private

  # RENDERING #################################################################

  def tab = " " * TAB

  def list_to_lines(items = @items, lines = [])
    items.each do |item|
      item_to_lines(item, lines)
      list_to_lines(item.children, lines)
    end
    lines
  end

  def item_to_lines(item, lines)
    width = @width - item.left_part_width
    sublines = content_to_lines(content: item.content, width:)
    sublines.each_with_index do |line, i|
      sign = i.zero? ? item.sign : " " * item.sign.size
      prefix = "#{item.indents}#{sign}"
      lines << "#{prefix} #{line}"
    end
  end

  # FORMATING #################################################################

  def format(string)
    @items = []
    @last_added = nil

    string_items = string.split(/((?:.(?:\\\n)?)*?)\n/).reject(&:empty?)
    string_items.each do |line|
      left_part = line.slice!(/^ *([-*+](?: \[[Xx ]\])?|\d+[.)]) /)
      next @last_added.content.append_str(" #{line}") unless left_part

      indent_level = left_part.slice!(/^ */).size / 2
      indent_diff = indent_level - @last_added.indent_level if @last_added
      parent = indent_level.zero? ? nil : find_parent(@last_added, indent_diff)

      items_opts = {
        tab: TAB,
        type: find_type(left_part),
        indent_level:,
        parent:,
        order_nb: parent ? parent.children.size : @items.size,
        content: Text.new(line)
      }
      add_item(parent, items_opts)
    end
  end

  def find_type(left_part)
    case left_part
    when /\d/ then :ordered
    when /\[[Xx]\]/ then :checkedbox
    when /\[ \]/ then :uncheckedbox
    else
      :unordered
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

# Block receives a type and raw content from the Parser.
# It formats its content regarding to its type.
class Block
  attr_reader :content

  def initialize(**args)
    @type = args[:type]
    # @spec = nil
    @content = format(args[:content])
  end

  private

  def format(content)
    case @type
    when :codeblock then content
    when :unord_list then list_content(content)
    else
      strip_and_squeeze(content)
    end
  end

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end

  # LIST ######################################################################

  def find_parent(item, diff)
    if diff.positive? then item
    elsif diff.zero? then item[:parent]
    else
      find_parent(item[:parent], diff + 1)
    end
  end

  def list_content(content)
    content = content.squeeze("\n").split("\n")
    first_line = strip_and_squeeze(content.first)[2..]
    first_item = {indent_level: 0, parent: nil, content: first_line, children: []}
    last_added = first_item

    content[1..].each_with_object([first_item]) do |line, items|
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

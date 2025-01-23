class ListItem
  attr_reader :parent, :children, :indent_level, :sign
  attr_accessor :content

  def initialize(opts)
    @content = opts[:content]
    @type = opts[:type]
    @tab = opts[:tab]
    @parent = opts[:parent]
    @children = opts[:children] || []
    @indent_level = opts[:indent_level] || 0
    @order_nb = opts[:order_nb]
    @sign = find_sign
  end

  def indent_width
    return tab.size if @indent_level.zero?
    left = @parent.indent_width + @parent.sign.size + 2
    return left unless @type == :ordered

    left - @sign.size + 2
  end

  def left_part_width = indent_width + @sign.size + 1

  def indents = " " * indent_width

  private

  def tab = " " * @tab

  def to_downcase_roman(n)
    romans = {x: 10, v: 5}
    res = ""
    romans.each do |roman, val|
      nb = n / val
      n %= val
      res += roman.to_s * nb
      return "#{res}i#{roman}" if n == val - 1
    end
    "#{res}#{"i" * n}"
  end

  def find_ordered_sign
    case @indent_level
    when 0 then "#{@order_nb + 1}."
    when 1 then "#{to_downcase_roman(@order_nb + 1)}."
    else
      "#{(@order_nb + 97).chr}."
    end
  end

  def find_unordered_sign
    case @indent_level
    when 0 then "•"
    when 1 then "◦"
    else "▪"
    end
  end

  def find_sign
    case @type
    when :ordered then find_ordered_sign
    when :unordered then find_unordered_sign
    when :checkedbox then "☑" # 🗹 🮱 🗹 ☑☒
    when :uncheckedbox then "☐" # ☐ ◼
    else
      raise "This should never happen."
    end
  end
end

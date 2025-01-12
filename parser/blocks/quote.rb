require_relative "block"
require_relative "text"
require_relative "text_renderer"

class QuoteItem
  attr_reader :nest, :text

  def initialize(nest, text)
    @nest = nest
    @text = text
  end
end

class Quote < Block
  def render(**opts)
    @width = opts[:width]
    @content.map.with_index do |item, i|
      next_more_nested = @content[i + 1] ? content[i + 1].nest > item.nest : false
      prefix = TextRenderer.stylized_string("▊ " * item.nest, :quote)
      width = @width - (item.nest * 2)

      lines = content_to_lines(content: item.text, width:).join("\n#{prefix}")
      next_more_nested ? "#{prefix}#{lines}\n#{prefix}" : "#{prefix}#{lines}"
    end.join("\n")
  end

  private

  # FORMATING #################################################################

  # We cant nest a blockquote like a list: once we nest, we cant "de-nest"
  def format(content)
    @nest_level = 1
    @lines = []

    content = strip_and_squeeze(content).split("\n")
    content.each do |line|
      left_part = line.slice!(/^( *>)+ ?/)
      next concatenate_with_last(line) unless left_part

      nest_level = left_part.count(">")

      if nest_level > @nest_level
        @nest_level = nest_level
      elsif line.empty?
        next @lines << QuoteItem.new(nest_level, Text.new(nil))
      elsif @lines.any? && @lines.last.text.spans.any?
        next concatenate_with_last(line)
      end

      @lines << QuoteItem.new(@nest_level, Text.new(line, default_styles: [:quote]))
    end

    @lines
  end

  def concatenate_with_last(line)
    @lines.last.text.append_str(line)
  end
end

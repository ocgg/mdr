require_relative "block"
require_relative "text"

class Quote < Block
  def render(**opts)
    @lines.join("\n")
  end

  private

  # We cant nest a blockquote like a list: once we nest, we cant "de-nest"
  def format(content)
    @nest_level = 0
    @lines = []

    content = strip_and_squeeze(content).split("\n")
    content.each do |line|
      left_part = line.slice!(/^( *>)+ ?/)
      next concatenate_with_last(line) unless left_part

      nest_level = left_part.count(">") - 1

      if nest_level > @nest_level
        @nest_level = nest_level
      elsif line.empty?
        next @lines << {nest: @nest_level, text: Text.new(nil)}
      elsif @lines.any? && @lines.last[:text].spans.any?
        next concatenate_with_last(line)
      end

      @lines << {nest: @nest_level, text: Text.new(line)}
    end

    @lines
  end

  def concatenate_with_last(line)
    @lines.last[:text].concatenate!(line)
  end
end

# Block receives a type and raw content from the Parser.
# It formats its content regarding to its type.
class Block
  attr_reader :content

  def initialize(content)
    # @type = args[:type]
    # @spec = nil
    @content = format(content)
  end

  private

  # FORMATING #################################################################

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end

  # RENDERING #################################################################

  def content_to_lines(width: @width, word_wrap: true, align: nil)
    lines_helper = LinesHelper.new(width, word_wrap, align)

    @content.spans.each_with_object(lines_helper) do |span, lh|
      lh.make_lines!(span)
    end
    lines_helper.finish_line!
    lines_helper.lines
  end
end

class LinesHelper
  attr_reader :lines
  attr_accessor :line, :count

  STYLES = {
    bold: 1,
    dim: 2,
    italic: 3,
    underline: 4,
    strike: 9
  }
  NOSTYLE = "\e[0m"

  def initialize(width, word_wrap, align)
    @word_wrap = word_wrap
    @width = width
    @align = align
    @lines = []
    @line = ""
    @just_resetted = true
    @count = 0
  end

  def make_lines!(span)
    # add style seq
    span_styles = seq_from(span.styles)
    @line += span_styles

    words = span.content.split(" ")
    add_space_to_line if !line_empty? && fits_in_line?(words[0])
    @just_resetted = false

    words.each_with_index do |word, i|
      if fits_in_line?(word)
        add_word_to_line(word)
      else
        finish_line!
        reset_line(span_styles, word)
      end
      add_space_to_line if fits_in_line?(words[i + 1])
    end
  end

  def finish_line!
    manage_alignment
    @lines << "#{NOSTYLE}#{@line}#{NOSTYLE}"
    @count = 0
    @line = ""
  end

  private

  def line_empty?
    @line == "" || @just_resetted
  end

  # Returns the corresponding escape sequence from styles names
  def seq_from(stylenames)
    return "" if stylenames.empty?
    stylenames.map! { |name| STYLES[name] }
    "\e[#{stylenames.join(";")}m"
  end

  def fits_in_line?(word)
    return false if word.nil?
    @count + word.size + 1 <= @width
  end

  def add_word_to_line(word)
    @line += word
    @count += word.size
  end

  def add_space_to_line
    @line += " "
    @count += 1
  end

  def manage_alignment
    return unless @align
    case @align
    when :center
      diff = (@width - @count)
      spaces_nb = diff / 2
      lspaces = " " * spaces_nb
      rspaces = diff.odd? ? " #{lspaces}" : lspaces
      @line = "#{lspaces}#{@line}#{rspaces}"
    end
  end

  def reset_line(start_seq = nil, first_word = nil)
    @line = start_seq || ""
    add_word_to_line(first_word) if first_word
    @just_resetted = true unless first_word
  end
end

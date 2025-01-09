class CodeRenderer
  attr_reader :lines

  NOSTYLE = "\e[0m"

  COL_SEQ = "\e[38;2;38;38;38;m"
  BGCOL_SEQ = "\e[48;2;38;38;38;m"
  LANG_SEQ = "\e[38;2;120;120;120;m"

  def initialize(width)
    @width = width
    @seq_stack = []
    @lines = []
    @line = "#{BGCOL_SEQ} "
    @count = 1
  end

  def codeblock(code, lang)
    upline = "#{COL_SEQ}#{codeblock_separator(lang)}#{NOSTYLE}"
    downline = "#{COL_SEQ}#{codeblock_separator}#{NOSTYLE}"

    # TODO: fill, to line, padding
    # code.gsub!(/(\e\[0m)/, "\1#{BGCOL_SEQ}")
    midlines = code_with_escapes_to_lines(code).join("\n")

    "#{upline}\n#{midlines}\n#{downline}"
  end

  private

  def codeblock_separator(lang = nil)
    return "▀" * @width if lang.nil?
    return "▄" * @width if lang.empty?

    right = "#{LANG_SEQ} #{lang} #{NOSTYLE}"
    left = "▄" * (@width - (lang.size + 2))
    "#{left}#{right}"
  end

  def finish_line
    # fill for bg color
    @line += " " * (@width - @count) if @count < @width
    # Reset styles at end of line (for future columns)
    @line += NOSTYLE
    @lines << @line
  end

  def reset_line_styles
    @seq_stack = []
    @line += NOSTYLE + BGCOL_SEQ
  end

  def add_style_seq_to_line(style_seq)
    @seq_stack << style_seq
    @line += style_seq
  end

  def is_reset?(chunk) = chunk == NOSTYLE

  def is_seq?(chunk) = chunk.match?(/\e\[[\d;]*m/)

  def code_with_escapes_to_lines(code)
    chunks = code.split(/(\e\[[\d;]*m)/).reject(&:empty?)

    chunks.each do |chunk|
      next reset_line_styles if is_reset?(chunk)
      next add_style_seq_to_line(chunk) if is_seq?(chunk)

      chunk.each_char do |char|
        # If end of line
        if @count == @width - 1 || char == "\n"
          finish_line
          # Reset new line, with undergoing style & opts styles
          @line = @seq_stack.reverse.join + BGCOL_SEQ + " "
          @count = 1
        end
        next if char == "\n"

        @line += char
        @count += 1
      end
    end
    finish_line
    @lines
  end

  class << self
    # def spans_to_string(spans)
    #   spans.map do |span|
    #     seq = seq_from(span.styles)
    #     "#{seq.empty? ? NOSTYLE : seq}#{span.content}#{NOSTYLE}"
    #   end.join
    # end
    #
    # # Returns the corresponding escape sequence from styles names
    # def seq_from(stylenames)
    #   return "" if stylenames.empty?
    #   stylenames.map! { |name| STYLES[name] }
    #   "\e[#{stylenames.join(";")}m"
    # end
  end
end

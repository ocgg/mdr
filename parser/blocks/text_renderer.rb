class TextRenderer
  STYLES = {
    bold: 1,
    dim: 2,
    italic: 3,
    underline: 4,
    strike: 9
  }
  NOSTYLE = "\e[0m"

  def initialize(width, align)
    @width = width
    @align = align
    @lines = []
    @line = ""
    @just_resetted = true
    @count = 0
  end

  def codeblock(code, lang)
    bgcol_seq = "\e[48;2;45;45;45;m"
    col_seq = "\e[38;2;45;45;45;m"

    upline = "#{col_seq}#{codeblock_separator(lang)}#{NOSTYLE}"
    downline = "#{col_seq}#{codeblock_separator}#{NOSTYLE}"

    code.gsub!(/(\e\[0m)/, "\1#{bgcol_seq}")
    midline = "#{bgcol_seq}#{code}#{NOSTYLE}"

    "#{upline}\n#{midline}\n#{downline}"
  end

  def make_lines(content)
    content.spans.each do |span|
      # add style seq
      span_styles = self.class.seq_from(span.styles)
      @line += span_styles

      # TODO/TOFIX: space & styles managment
      words = span.content.split(" ")
      add_space_to_line if !line_empty? && fits_in_line?(words[0])

      @just_resetted = false
      words.each_with_index do |word, i|
        if fits_in_line?(word)
          add_word_to_line(word)
        else
          finish_line
          reset_line(span_styles, word)
        end
        add_space_to_line if fits_in_line?(words[i + 1])
      end
    end
    finish_line
    @lines
  end

  def finish_line
    manage_alignment
    @lines << "#{NOSTYLE}#{@line}#{NOSTYLE}"
    @count = 0
    @line = ""
  end

  private

  def codeblock_separator(lang = nil)
    return "▀" * @width if lang.nil? || lang.empty?

    lang_seq = "\e[38;2;120;120;120;m"
    right = "#{lang_seq} #{lang} #{NOSTYLE}"
    left = "▄" * (@width - (lang.size + 2))
    "#{left}#{right}"
  end

  def line_empty?
    @line == "" || @just_resetted
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

  class << self
    def spans_to_string(spans)
      spans.map do |span|
        seq = seq_from(span.styles)
        "#{seq.empty? ? NOSTYLE : seq}#{span.content}#{NOSTYLE}"
      end.join
    end

    # Returns the corresponding escape sequence from styles names
    def seq_from(stylenames)
      return "" if stylenames.empty?
      stylenames.map! { |name| STYLES[name] }
      "\e[#{stylenames.join(";")}m"
    end
  end
end

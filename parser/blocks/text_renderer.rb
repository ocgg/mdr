class TextRenderer
  STYLES = {
    bold: 1,
    dim: 2,
    italic: 3,
    underline: 4,
    strike: 9
  }
  NOSTYLE = "\e[0m"

  def initialize(width, align = nil)
    @width = width
    @align = align
    @lines = []
    @line = ""
    @just_resetted = true
    @count = 0
  end

  # Receives a Text instance (likely the @content of a Block), returns an array
  # of "lines" (String) that are the concatenated content of the Text's spans,
  # formatted with corresponding styles escape sequences. Lines are cut to not
  # exceed @width characters (escapes sequences are not taken into account).
  def make_lines(text)
    text.spans.each do |span|
      @just_resetted = false

      span_styles_seq = self.class.seq_from(span.styles)
      @line += span_styles_seq

      words_and_spaces = span.content.split(/\b/)
      words_and_spaces.each do |word_or_space|
        if fits_in_line?(word_or_space)
          add_to_line(word_or_space)
        else
          finish_line
          reset_line(span_styles_seq, word_or_space)
        end
      end
      @line += NOSTYLE if span.styles.any?
    end
    finish_line
    @lines
  end

  private

  def fits_in_line?(word)
    @count + word.size <= @width
  end

  def add_to_line(str)
    @line += str
    @count += str.size
  end

  def finish_line
    manage_alignment
    @lines << "#{NOSTYLE}#{@line}#{NOSTYLE}"
    @count = 0
    @line = ""
  end

  def reset_line(start_seq = nil, first_word = nil)
    @line = start_seq || ""
    add_to_line(first_word.lstrip)
    @just_resetted = true unless first_word
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

  # Methods that dont need any instance variable are set as class methods
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

require_relative "text"

class TextRenderer
  STYLES = {
    bold: 1,
    dim: 2,
    italic: 3,
    underline: 4,
    strike: 9,
    # CUSTOM
    inline_code: [48, 5, 237, 38, 5, 251],
    inline_code_around: [38, 5, 237],
    quote: [38, 5, 247],
    link: [4, 38, 2, 120, 160, 230]
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

      if span.link?
        @line += span.link_start_seq
        span.content.spans.each do |link_span|
          lines_from_span(link_span)
        end
        @line += span.link_end_seq if span.link?
      else
        lines_from_span(span)
      end
    end
    finish_line
  end

  private

  def lines_from_span(span)
    span_styles_seq = TextRenderer.seq_from(span.styles)
    @line += span_styles_seq
    tokens = span.content.split(/\b/)
    tokens.each do |token|
      if !fits_in_line?(token) || token == "\n"
        finish_line(span_styles_seq, token)
      else
        add_to_line(token)
      end
    end
    @line += NOSTYLE if span.styles.any?
  end

  def fits_in_line?(token)
    fits = @count + token.size <= @width
    if !fits && token.end_with?(" ")
      fits = @count + token.rstrip.size <= @width
    end
    fits
  end

  def add_to_line(token)
    @line += token
    @count += token.size
  end

  def finish_line(start_seq = nil, first_word = nil)
    manage_alignment
    @line.rstrip! unless @align == :center
    @lines << "#{NOSTYLE}#{@line}#{NOSTYLE}"
    @line = start_seq || ""
    @count = 0
    first_word ? add_to_line(first_word.lstrip) : @just_resetted = true
    @lines
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
    def stylized_string(string, *stylenames)
      "#{NOSTYLE}#{seq_from(stylenames)}#{string}#{NOSTYLE}"
    end

    def spans_to_string(spans)
      spans.map do |span|
        seq = seq_from(span.styles)
        "#{seq.empty? ? NOSTYLE : seq}#{span.content}#{NOSTYLE}"
      end.join
    end

    # Returns the corresponding escape sequence from styles names
    def seq_from(stylenames)
      return "" if stylenames.empty?
      stylecodes = stylenames.map { |name| STYLES[name] }.flatten
      "\e[#{stylecodes.join(";")}m"
    end
  end
end

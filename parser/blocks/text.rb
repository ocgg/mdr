class Span
  attr_reader :content, :styles

  def initialize(string, *styles)
    @content = string
    @styles = styles
  end

  def link? = !!@url
end

class Link < Span
  def initialize(content, url, *styles)
    @content = Text.new(content, default_styles: styles)
    @styles = styles
    @url = url
  end

  def link_start_seq = "\e]8;;#{@url}\e\\"

  def link_end_seq = "\e]8;;\e\\"
end

class Text
  attr_reader :spans

  INLINE_STYLE_REGEX = /
    (?:
    # prefix
    (?<=(?<beforebegin>\W))?
    # opening tag
    (?<open_tag>\*\*\*|___|\*\*|__|\*|_|``|`|~~|~)
    # content
    (?<content>
      (?(<beforebegin>).|\w)
      (?:.\n?)*?
      (?<beforeend>\w)?
    )
    # closing tag
    (?<close_tag>\k<open_tag>)
    # suffix
    (?=(?(<beforeend>).|\W)|$)
    .*?
    )
  /x

  LINK_REGEX = /(?<link>\[.*?\]\(.*?\))/

  TEXT_REGEX = /#{INLINE_STYLE_REGEX}|#{LINK_REGEX}/

  def initialize(string, default_styles: [])
    @styles = default_styles
    @spans = string ? format(string) : []
  end

  def append_str(string) = spans_from(string)

  def prepend_span(span) = @spans.unshift(span)

  private

  def format(string)
    @spans = []
    spans_from(string)
  end

  def delimiter_to_style(delimiter)
    case delimiter
    when "***", "___" then [:bold, :italic]
    when "**", "__" then [:bold]
    when "*", "_" then [:italic]
    when "~~", "~" then [:strike]
    when "``", "`" then [:inline_code]
    else
      raise "Unknown delimiter '#{delimiter}'"
    end
  end

  # Must return @spans
  def inline_code_decorations(string)
    @spans << Span.new("🭒", :inline_code_around)
    @spans << Span.new(string, *@styles)
    @spans << Span.new("🭌", :inline_code_around)
  end

  # Must return @spans
  def add_span(string)
    @spans << Span.new(string, *@styles)
  end

  def spans_from_match_content(match_data)
    @styles += delimiter_to_style(match_data[:open_tag])
    spans_from(match_data[:content])
    @styles.pop # keep this here
  end

  def add_link_span(match_data)
    raw = match_data[0]
    text = raw.slice(/\[(.*?)\]/)[1..-2]
    url = raw.slice(/\((.*?)\)/)[1..-2]
    @spans << Link.new(text, url, *@styles + [:link])
  end

  def process_inline_styles(string, match_data, before_match, after_match)
    # Before match: there was no specific style, just add the span
    add_span(before_match) unless before_match&.empty?

    # Actual match content
    if match_data[:link]
      add_link_span(match_data)
    else
      # Check nested styles in match's content
      spans_from_match_content(match_data)
    end

    # After match: process the rest of the string
    spans_from(after_match)
  end

  def spans_from(string)
    return @spans if string.nil? || string.empty?
    return inline_code_decorations(string) if @styles.include?(:inline_code)

    match_data = string.match(TEXT_REGEX)
    return add_span(string) if match_data.nil?

    # $` and $' are provided by .match
    process_inline_styles(string, match_data, $`, $')
  end
end

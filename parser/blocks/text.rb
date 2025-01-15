class Span
  attr_reader :content, :styles

  def initialize(content, *styles)
    @content = content
    @styles = styles
  end
end

class Text
  attr_reader :spans

  INLINE_STYLE_REGEX = /
    # prefix
    (?<=(?<beforebegin>\W))?
    # opening tag
    (?<open_tag>\*\*\*|___|\*\*|__|\*|_|``|`|~~|~)
    # content
    (?<content>
      (?(<beforebegin>).|\w)
      .*?
      (?<beforeend>\w)?
    )
    # closing tag
    (?<close_tag>\k<open_tag>)
    # suffix
    (?=(?(<beforeend>).|\W)|$)
    .*?
  /x
  LINK_REGEX = /(\[.*\]\(.*\))/

  def initialize(string, **opts)
    @styles = opts[:default_styles] || []
    @spans = string ? format(string) : []
  end

  def append_str(string) = spans_from(string)

  def prepend_span(span)
    @spans.unshift(span)
  end

  private

  def delimiter_to_style(delimiter)
    case delimiter
    when "***", "___" then [:bold, :italic]
    when "**", "__" then [:bold]
    when "*", "_" then [:italic]
    when "~~", "~" then [:strike]
    when "``", "`" then [:inline_code]
    # Should never reach this line
    else raise "Unknown delimiter '#{delimiter}'"
    end
  end

  # Must return @results
  def inline_code_decorations(string)
    @results << Span.new("🭒", :inline_code_around)
    @results << Span.new(string, *@styles)
    @results << Span.new("🭌", :inline_code_around)
  end

  # Must return @results
  def add_span(string)
    @results << Span.new(string, *@styles)
  end

  def spans_from_match_content(match_data)
    @styles += delimiter_to_style(match_data[:open_tag])
    spans_from(match_data[:content])
    @styles.pop # keep this here
  end

  def spans_from(string)
    return @results if string.empty?
    return inline_code_decorations(string) if @styles.include?(:inline_code)

    match_data = string.match(INLINE_STYLE_REGEX)
    return add_span(string) if match_data.nil?

    # These are global variables provided by .match
    before_match = $`
    after_match = $'

    add_span(before_match) unless before_match.empty?
    spans_from_match_content(match_data)
    spans_from(after_match)
  end

  def format(string)
    @results = []
    string = string.strip.tr("\n", " ").squeeze(" ")
    spans_from(string)
  end
end
